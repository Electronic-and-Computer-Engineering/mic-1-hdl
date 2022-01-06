#!/usr/bin/env python3

"""
ECE Project Mic-1
Title: Program Converter for ijvm-files
Author: Florian Zwittnigg
Date: 17.11.2021
Rev.: 1.0 

This program convert a .ijvm into a .txt, which can be later
interpreted by a mic1 processor. The last row will be padded
so there are always 8 signs in one row (8 signs are equally
to 4 commands)
"""

import os
from posixpath import split
import sys
import argparse
import math

# Reading the file and hand over the content to main
def read_file(filename:str):
        f = open(f'{filename}', mode='rb')

        fileContent = f.read()
        f.close()

        return fileContent

# convert binary data to hex dataformat for ASCII
def convert_content(fileContent:bytes):
        hex_string = fileContent.hex()
        
        n = 8           # size of one row
        file_header = hex_string[0 : n]

        if(file_header != "1deadfad"):
                print("Header is not OK")
                quit()
        else:
                print("Header is OK") 

        mem_addr_pool = hex_string[n : 2*n] # represent the place of the constant pool in the memory
        mem_addr_pool_int = int(mem_addr_pool, 16)
        con_poolsize = hex_string[2*n : 3*n]
        size_pooldata = int(con_poolsize, 16)

        k = 3*n+(size_pooldata*2)           # end of pooldata 
        pooldata = hex_string[3*n : k]      

        mem_addr_text = hex_string[k : k + n] # represent the place of the text in the memory
        mem_addr_text_int = int(mem_addr_text, 16)
        con_textsize = hex_string[k + n : k + 2*n]
        textsize = int(con_textsize, 16)

        m = k +  2*n +(textsize*2) # end of textdata
        textdata = hex_string[k + 2*n : m]

        # print("Fileheader: " + file_header)
        # print("Adresse Pool: " + mem_addr_pool)
        # print("Adresse Pool in Dezimal: ", mem_addr_pool_int)
        # print("Größe der Pooldaten (Konstanten) in Hexadezimal: " + con_poolsize)
        # print("Größe des Pooldaten (Konstanten) in Dezimal: ",  size_pooldata)
        # print("Pooldaten: " + pooldata)

        # print("Adresse Text: " + mem_addr_text)
        # print("Adresse Textes in Dezimal: ", mem_addr_text_int)
        # print("Größe des Textes in Hexadezimal: " + con_textsize)
        # print("Größe des Textes in Dezimal: ",  textsize)
        # print("Textdaten Vor dem Padding: " + textdata)
        
        reversed_textdata = reverse_commands(textdata)

        new_hex_string = reversed_textdata + pooldata   # add constants at the end of string

        split_strings = [new_hex_string[index : index + n] + "\n" for index in range(0, len(new_hex_string), n)]

        return split_strings

# create .txt-File in same directory and write the converted data into it
def write_file(fileContent, filename):
        base = os.path.basename(filename)
        output_filename = os.path.splitext(base)[0]
       
        file = open(f'{output_filename}.txt', "w")

        file.writelines("// This file was created with ijvmtomem.py from " + base +  "\n")
        file.writelines(fileContent)
        
        file.close()

        return base

# bring the textdata in correct sequence
def reverse_commands(commands):
        reversed_word_buffer = ''

        for i in range(math.ceil(len(commands)/8)):
                word = commands[i*8:i*8+8]

                reversed_word = []

                for i in range(4):
                        byte = word[i*2:i*2+2]
                
                        if byte != '':  
                                reversed_word.append(byte)
                        else:
                                reversed_word.append('00')

                reversed_word = reversed_word[::-1]               
                reversed_word = ''.join(reversed_word)
                reversed_word_buffer = reversed_word_buffer + reversed_word
        
        # print(reversed_word_buffer)

        return reversed_word_buffer

if __name__=='__main__':
    #parsing commandline
    parser = argparse.ArgumentParser(description='Convert Binary to ASCII')
    parser.add_argument('filename', help='filename of binaryfile without file extension')
    args = parser.parse_args()
    
    content_of_file = read_file(args.filename)
    writable_content = convert_content(content_of_file)      

    base = write_file(writable_content, args.filename)

    print("Conversion successfully done. Saved as " + os.path.splitext(base)[0] + ".txt")