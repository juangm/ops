#!/usr/bin/python3
import string
import datetime

# Parameters
pathToFile = "resources/x.txt"
pathToNewFile = "resources/y.txt"
textToReplace = "xxxx"

# Open file and record file with timeSTAMP
text = open(pathToFile).read()
stamp = int(datetime.datetime.now().timestamp())
text = text.replace(textToReplace, str(stamp))
newTest = open(pathToNewFile, 'w')
newTest.write(text)
newTest.close()
