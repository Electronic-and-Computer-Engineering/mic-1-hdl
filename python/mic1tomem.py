#!/usr/bin/env python3

"""
ECE Project Mic-1
Title: Program Converter for mic1 files
Author: Florian Zwittnigg
Date: 17.11.2021
Rev.: 1.0

This program convert a .mic1 into a .txt, which can be later
interpreted by a mic1 processor.
"""

import os
import sys
import argparse

# Reading the file and hand over the content to main
def read_file(filename:str):
    f = open(f'{filename}', mode='rb')
    fileContent = f.read()
    f.close()

    return fileContent

# convert binary data to hex dataformat for ASCII
def convert_content(fileContent:bytes):
    hex_string = fileContent.hex()

    n = 9
    #split_strings = [hex_string[index : index + n] for index in range(8, len(hex_string), n)]
    file_header = hex_string[0 : n]
    if(file_header != "123456780"):
        print("Header is not OK")
        quit()
    else:
        print("Header is OK")

    split_strings = ''.join(hex_string)
    split_strings = split_strings[8 : -1]
    new_string = ([split_strings[index * 10 : index * 10 + 9] + "\n" for index in range(0, len(split_strings)//10 +1)])

    return new_string

# create .txt-File in same directory and write the converted data into it
def write_file(fileContent, filename):
    base = os.path.basename(filename)
    output_filename = os.path.splitext(base)[0]

    file = open(f'{output_filename}.mem', "w")

    file.writelines("// mic1tomem: convert .mic1-files to .mem-files \n" + "// Loading " + base +  "\n")
    file.writelines(fileContent)

    file.close()

    return base

if __name__=='__main__':
    #parsing commandline
    parser = argparse.ArgumentParser(description='Convert Binary to ASCII')
    parser.add_argument('filename', help='filename of binaryfile with file extension')
    args = parser.parse_args()
    base = os.path.basename(args.filename)
    print("mic1tomem: convert .mic1 files to .mem files")
    print("Loading " + base +  "\n")

    content_of_file = read_file(args.filename)
    writable_content = convert_content(content_of_file)
    write_file(writable_content, args.filename)

    print("Conversion done. Saved as " + os.path.splitext(base)[0] + ".mem")
