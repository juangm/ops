#!/usr/bin/python3
import argparse
import boto3
import progressbar
import os

def create_session(profile):
    session = boto3.session.Session(profile_name=profile)
    return session.client("s3")

def upload_progress(chunk):
    up_progress.update(up_progress.currval + chunk)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('env',
                        metavar='path',
                        type=str,
                        help='Environment to select DEV or TEST')

    args = parser.parse_args()
    environment = args.env

    # Create session and get variables
    if environment == 'dev':
        config = {
            "AWS_PROFILE": "Quality",
            "BUCKET_NAME": "qa-jenkins-s3-iwb",
            "BUCKET_MAIN_FOLDER": "report/Automated_Dev_DEVELOP_BRANCH/",
            "BUCKET_DOWNLOAD_FOLDER": "report/Automated_Dev_DEVELOP_BRANCH/{}",
            "OUTPUT_FOLDER": "/reports/Dev/{}"
        }
    else:
        config = {
            "AWS_PROFILE": "Quality",
            "BUCKET_NAME": "qa-jenkins-s3-iwb",
            "BUCKET_MAIN_FOLDER": "report/Automated_Test_DEVELOP_BRANCH/",
            "BUCKET_DOWNLOAD_FOLDER": "report/Automated_Test_DEVELOP_BRANCH/{}",
            "OUTPUT_FOLDER": "/reports/Test/{}"
        } 
    s3_client = create_session(config["AWS_PROFILE"])

    latest_builds = s3_client.list_objects_v2(
        Bucket=config["BUCKET_NAME"],
        Prefix=config["BUCKET_MAIN_FOLDER"],
        Delimiter="/")
    
    print("List of the objects store in amazon:\n")
    for obj in latest_builds["CommonPrefixes"]:
        print(obj['Prefix'])
    build_number = input("\nSelect the number of the object to download => ")

    up_progress = progressbar.progressbar.ProgressBar()

    # Download all the elements in the folder
    list_download = s3_client.list_objects_v2(
        Bucket=config["BUCKET_NAME"],
        Prefix=config["BUCKET_DOWNLOAD_FOLDER"].format(build_number))
    
    object_path = os.getcwd() + config["OUTPUT_FOLDER"].format(build_number)
    if not os.path.exists(object_path):
        try:
            os.makedirs(object_path)
        except OSError as exc: # Guard against race condition
            raise
    for obj in list_download["Contents"]:
        file_name = obj["Key"].split("/")
        print("Downloading file {} ....".format(file_name[3]))
        # Add progress bar for the downloading process
        up_progress = progressbar.progressbar.ProgressBar(maxval=obj["Size"])
        up_progress.start()
        s3_client.download_file(
            config["BUCKET_NAME"],
            obj["Key"],
            object_path + "/" + file_name[3],
            Callback=upload_progress
        )        
        up_progress.finish()
