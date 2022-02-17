# USER MANUAL

## Convert files

### Convert .mic1-files

In order that the synthesis tools can read the .mic1- and .ijvm-files, they must be converted into .mem with a certain structure.

To convert the .mic1-file the program mic1tomem.py has to executed with the following command in the terminal:

```
$ python3 PATH/mic1tomem.py PATHOFFILE/FILENAME.mic1
```

This will convert the .mic1-file into a .mem-file and store it in the same folder as the .mic1-file from it was read.

### Convert .ijvm-files

To convert the .ijvm-file the program ijvmtomem.py has to executed with the following command in the terminal:

```
$ python3 PATH/ijvmtomem.py PATHOFFILE/FILENAME.ijvm
```

This will convert the .ijvm-file into a .mem-file and create a define file, which has the name *defines\_FILENAME.sv.* The files will be store in the same folder as the .ijvm-file from it was read. Because this file has an area, where a certain stack size will be reserved, the additional to reserve stack size can be chosen by add the following parser at the end of the entered command:

```
$ python3 PATH/ijvmtomem.py PATHOFFILE/FILENAME.ijvm -st 16
```

The entered number at the end are adding the according words to the file. By default it is 64. Instead of *-st* also *--stacksize* can be entered.

## MIC1 Basys3 Implementation

To deploy the MIC1 on the Basys3 board the file top\_level\_basys3.xpr in the top-level subfolder must first be opened in Vivado.

### Elaboration & Constraints

Click on "*Open Elaborated Design*" in the left sidebar then switch to "I/O Planning" in the top right corner.

![IO\_planing.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/IO_planing.png?fileId=5561400#mimetype=image%2Fpng&hasPreview=true)Then select "*I/O Ports*" in the lower section of the window.

![IO\_Ports.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/IO_Ports.png?fileId=5561398#mimetype=image%2Fpng&hasPreview=true)The I/O pins have to be assigned as follows:

![IO\_Port\_assignment.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/IO_Port_assignment.png?fileId=5561399#mimetype=image%2Fpng&hasPreview=true)After a click on the Save button, the following dialog appears:

![save\_sonstr\_file.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/save_sonstr_file.png?fileId=5561407#mimetype=image%2Fpng&hasPreview=true)

### Synthesis, Implementation & Bitstream-Generation

After elaboration and pin assignment are completed, click on "*Run Synthesis*" in the left sidebar. When synthesis is complete, the following dialog box appears. Select "*Run Implementation*" if it is not already selected:

![synthesis\_run\_complete.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/synthesis_run_complete.png?fileId=5561408#mimetype=image%2Fpng&hasPreview=true)After completing the implementation, select „*Generate Bitstream*“ in the dialog box if it is not already selected:

![implementation\_run\_complete.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/implementation_run_complete.png?fileId=5561401#mimetype=image%2Fpng&hasPreview=true)Once the bitstream generation is complete, select "*Open Hardware Manager*" in the following dialog box:

### ![Bitstream\_generation\_complete.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/Bitstream_generation_complete.png?fileId=5561397#mimetype=image%2Fpng&hasPreview=true)

### Hardware Manager

After starting the Hardware Manager, right-click on "*Program and Debug*" in the left sidebar to get to the Bitstream Settings.

![change\_bitstream\_options.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/change_bitstream_options.png?fileId=5561396#mimetype=image%2Fpng&hasPreview=true)In the Bitstream Settings place a check mark at "*-bin\_file\**".

![ch\_ch\_ch\_changes.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/ch_ch_ch_changes.png?fileId=5561402#mimetype=image%2Fpng&hasPreview=true)Now connect the Basys3 board to the computer and select "*Open Target*" in the main window then " *Auto Connect*" in the following menu.

![connect\_target.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/connect_target.png?fileId=5561403#mimetype=image%2Fpng&hasPreview=true)Now the Configuration Memory Devices Properties have to be adjusted in the hardware window. Right-click on "*s25fl032p-spi-x1\_x2\_x4*" and select the corresponding option in the menu. Then enter the path to the bin file under "*Programming File*" as follows:

„*STORAGE LOCATION/mic-1-project/verilog/top-level/top\_level\_basys3.runs/impl\_1/mic1\_basys3.bin*“

![configuration\_memory\_device\_properties.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/configuration_memory_device_properties.png?fileId=5561405#mimetype=image%2Fpng&hasPreview=true)Before the Basys3 can be programmed it must be checked if the Boot Mode Jumper is set to "*SPI Flash*" position, so that the FPGA is configured automatically at startup:

![basys3\_jumper\_position.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/basys3_jumper_position.png?fileId=5561395#mimetype=image%2Fpng&hasPreview=true)Once these preparations are completed, the device can be programmed:

![program\_device.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/program_device.png?fileId=5561404#mimetype=image%2Fpng&hasPreview=true)When programming is complete, the Done-, Power-, and LDI4-LEDs should be lit, and the 7-segment display should also be weakly illuminated.

![basys3\_Board\_functioning.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/basys3_Board_functioning.png?fileId=5561394#mimetype=image%2Fpng&hasPreview=true)

## Connection via UART to the FPGA

To communicate with the FPGA you need a terminal program for serial communication. In this case hTerm is used.

1\.       Download hTerm from the following website:\
<https://www.der-hammer.info/pages/terminal.html>

2\.       Unpack the zip archive and start **hTerm**.

3\.       First of all you need configurate the communicator right. The following changes need to be made:

* Select the COM port to which the FPGA is connected.
* Select the Baud rate 9600, 8 data bits, 1 stop bit and no parity bit.
* Select Newline at LF and Send on enter LF.

4\.       After you have made the changes, click **Connect**.

5\.       Now you can communicate with the FPGA trough the input control.\
The messages from the FPGA will be displayed in the "Received Data" Tab.

![hTerm.png](/Projekt/Dokumentation/_DOCUMENTATION_PICTURES/User_Manual/hTerm.png?fileId=5561600#mimetype=image%2Fpng&hasPreview=true)