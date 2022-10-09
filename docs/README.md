---
title: Contents
weight: 2
type: contents
class: brief
---

# **Meter NIC Config Tool User Guide v1.0.0**

This simple application will allow a user to select __________ (DailyRead, DailyShift, OnRead) for readings supported by the endpoint, and feed them into an instance of the `Y84000-PTR | SRFN XML Configuration Creation Tool`.

## Notice

I am an intern, and this is my first time doing something like this, so please bear with me. 

This is the first deployed version. There will be bugs. The tool will break, no matter how many errors I try to anticipate. 

I sincerely apologize if this tool does not function how you want it to. The best thing you can do for me is  [contact](#contact) me if you happen to:

- Experience an unknown error
- Have tips on improving the functionality of the app
- Have recommendations of new features
- Spot useless features that can be removed
- Have any questions at all regarding anything about this tool
- Be directed by this document to do so

I greatly appreciate your patience and understanding, and I hope to eventually produce something worthwhile.

# Tool Overview

This tool attempts to address the shortcomings and complications that come with the process of configuring a customer's endpoint, specifically the process of selecting _________ for readings that the customer wants included in their endpoint.

After creating a MeterMate file for the customer, this tool will take the MeterMate file, and feed it into a sheet of the `Y84000-PTR | SRFN XML Configuration Creation Tool`. Formulas on this sheet will then calcluate the supported readings for that MeterMate configuration, and present the user with the option to select ______ for only the readings indicated by these calculations. 

The user will then make selections, and review them. After review, they will be prompted to export the selection, which will write them to a copy of the `Y84000-PTR | SRFN XML Configuration Creation Tool`, which will populate the relevent sheets with the selections. 


## Usage

For the application to run properly, you must have:
-  the executable downloaded on your machine (currently called `Meter NIC Reading Selector.exe`)
- a `config/` folder in the same directory as the executable. Please see the [Setup](#setup) section to correctly configure this folder before running the tool.

**Once you are positive that you have completed the [Setup](#setup) section correctly, follow these steps:**

1. Make sure you have an updated version of the `Y84000-PTR | SRFN XML Configuration Creation Tool [REV:R]` downloaded at a convenient location on your machine. If not, see [Getting the Y84000-PTR Tool](#getting-the-y84000-ptr-tool).

2. Obtain a MeterMate program `file TODO` and make sure it is downloaded at a convenient location on your machine. If not, see [Getting the MeterMate Program](#getting-the-metermate-program).

3. Once you have these files and you are absolutely certain that the [Setup](#setup) as been performed correctly, simply run the executable.

4. For any errors experienced during runtime, see [Handling Errors](#handling-errors). 

## Setup

For the application to be run properly, the location of the executable **must** have the structure below. Note that the `hidden_data/` folder is optional, and if it is not included it will be generated at runtime. (It's a lot faster if you do include it)

```
├── Meter NIC Reading Selector.exe
└── config/
    ├── config.json
    └── hidden_data/ (OPTIONAL)
        ├── ReadingsMap-xxxxxxxx.json (OPTIONAL)
        └── log.txt (OPTIONAL)
```

Please see the below section to determine if you need to make changes to the config file. (todo file)

### `config.json`

The following does not need to be modified to properly run the program, but must be changed if:

- The names of the Input/Output Y84000 tabs change
- The cell mappings of the Input/Output Y84000 tabs change
- The version changes
- The filename format of hidden data files wants to be changed
- The messge limits are changed
- The key names from the reading types .xml file changes
- The validation codes for a reading category (BulkQuantity or Max/Cumulative Demand) change

If one of these is true, locate the `config.json` file in the  `config/` directory, and ensure these fields are set correctly:

```python
'INPUT_SHEET_NAME' # The name of the sheet in the Y84000-PTR Excel file where data (MeterMate data, selected messages) will be written to
'OUTPUT_SHEET_NAME' # The name of the sheet in the Y84000-PTR Excel file where data (supported readings) will be read from
'CELL_MAP' # Cell names that will be written to
    - 't12' # Where the MeterMate table-12 value is written
    - 't14' # Where the MeterMate table-14 value is written
    - 'dsBuReadingTypes' # Where the DailyShift messages are written
    - 'drReadList' # Where the DailyRead messages are written
    - 'orReadList' # Where the OnRead messages are written

'VERSION' # The current version of the tool

'READINGS_MAP_FN_FORMAT' # The format of the filename for the .json file that contains a map of all reading type data (%Y = year, %m = month, %d = day)

'DS_MESSAGE_LIMIT' # Amount of DailyShift selections that are allowed
'DR_MESSAGE_LIMIT' # Amount of DailyRead selections that are allowed
'OR_MESSAGE_LIMIT' # Amount of OnRead selections that are allowed

'READING_TYPE_KEY_NAMES' # Key names from the reading type .xml file
    - 'name' # Name of the reading type
    - 'enum' # HEEP enumeration of the reading type
    - 'code' # READING_TYPE_2ND_ED of the reading type
    - 'describption' # Any comment that is possibly associated with the reading type
    - 'popular_val' # Value associated with the popularity of the reading

'xxxxx_VALIDATION_CODES' # Description below
# What the READING_TYPE_2ND_ED codes of a group of readings should be.
# 
# Since the generated supported readings returns a 'group' of similar readings
# that differ only according to present/previous and time of use A/B/C/D,
# they are validated using each reading's code. 
#
# The 10 readings are all compared to each other, and the tool will inspect
# all 17 parts of each reading's code, making sure they conform to these codes.
#
# Ex. "3": ["1", "9", "9", "9", "9", "1", "9", "9", "9", "9"]
# This means that for the 10 readings in a group, the 3rd index of their
# codes should be 1 for PresentMain, 9 for PresentTOUA...1 for PreviousMain, etc.
#
# Ex. "8": "same",
# This means that for the 10 readings in a group, the 8th index of their
# codes should all be the same (all 72, all 45, etc.)
```


## Error Handling

During the execution of the program, there are several instances where an error can occur. Here is a list of potential errors, and steps to take to possibly fix them.

Error Code | Description | Potential Fixes
--- | --- | ---
0x101 | During initialization, the tool was unable to find existing reading types data (`File D`link). This means that the user must supply new reading types (`File C`link) to the tool. | If there has been a recent change to the reading types, then disregard this message and import `FIle C` on the main screen (see TODO link to how to get xml from spreadsheet). <br/><br/>If not, make sure that there exists a `.json` file in `config/hidden_data/` (TODO see file structure link). <br/><br/>If the file seems to be in the right place, there may have been an error validating the file, and you must import a new version of `File C`. Delete the invalid file.
0x201 | The supplied reading type data (`File C`link) was unable to be validated against the schema. This could be due to an incorrect file being provided.  | Ensure that the provided `File C` has been generated correctly (see TODO link to how to get xml from spreadsheet).<br/><br/> If it has, then this means that the `File C` does not agree with the tool’s schema that validates it. The tool will prompt you to download the schema for `File C` , which can then be used to compare to the `File C`, using an online schema validator (it’s much easier to see how they differ than what the tool uses).<br/><br/> It is possible that the tool’s schema needs to be updated, and in that case, see (TODO building executable link)
0x202 | The supplied MeterMate file (`File B`link) was unable to be validated against the schema. This could be due to an incorrect file being provided. | Ensure that the provided `File B` has been generated correctly (see TODO link to how to get metermate xml).<br/><br/>If it has, then this means that the `File B` does not agree with the tool’s schema that validates it. The tool will prompt you to download the schema for `File B` , which can then be used to compare to the `File B`, using an online schema validator (it’s much easier to see how they differ than what the tool uses).<br/><br/>It is possible that the tool’s schema needs to be updated, and in that case, see (TODO building executable link)
0x203 | The generated supported readings (`File E`), was unable to be validated against the schema. This means that the `File E` generated by `File A` is incorrectly formatted. | Ensure that the provided `File A` is up to date.<br/><br/>If it has, then this means that the `File E` does not agree with the tool’s schema that validates it. The tool will prompt you to download this schema and `File E` , which can then be compared using an online schema validator to see where they differ.<br/><br/>It is possible that the tool’s schema needs to be updated, where you must (TODO building executable link), or `File A` must be updated, where you should (TODO contact David Haynes)
0x301 | There was an unexpected error that occurred in the parsing of the provided `File C`. | Ensure that the provided `File C` is as intended. <br/><br/>This is a fatal error if the problem persists. Please contact the developer and provide `File F`.
0x302 | There was an unexpected error that occurred in the parsing of the provided `File B`. | Ensure that the provided `File B` is as intended. <br/><br/>This is a fatal error if the problem persists. Please contact the developer and provide `File F`.
0x303 | There was an unexpected error that occurred in the parsing of the generated supported readings `File E` | Ensure that the provided `File A` is up to date, and `File B` is as intended.<br/><br/>This is a fatal error if the problem persists. Please contact the developer and provide `File F`.
0x401 | While validating the supported readings provided by `File E`, an incorrect HEEP enumeration was encountered, or the `File E` was not well-formed. | Ensure that the provided `File A` is up to date, and `File B` is as intended.<br/><br/>This is a fatal error if the problem persists. Please contact the developer and provide `File F`.
0x900 | There was an error parsing the configuration files, specifically the initialization of a data structure the tool uses throughout runtime. | Ensure that the config files are set correctly (TODO link to setup).<br/><br/>This is a fatal error if the problem persists. Please contact the developer and provide `File F`.
0x901 | There was an error with the tool’s GUI. This is fatal. | Please contact the developer and provide `File F`.
0x904 | There was an error loading the supported readings from `File E` into the GUI. This is fatal. | Please contact the developer and provide `File F`.
0x905 | There was an error with the tool’s GUI and ability to update the counts of the selections. This is fatal. | Please contact the developer and provide `File F`.
0x906 | There was an error loading selected readings into an exportable state. This is fatal. | Please contact the developer and provide `File F`.
0x907 | There was an error exporting the selected readings. This is fatal. | Please contact the developer and provide `File F`.
0x909 | There was an unknown error. This is fatal | Please contact the developer and provide `File F`.




## Appendix

TODO fix filenames, then figure out if we need seperate sections for the new debug and update filemenus, or if they can just be mentioned in errors

In this document and in the tool, specific files will be referenced. To avoid confusion, please refer to this table.

Term | Definition
--- | ---
File Y - Y84000-PTR | The excel tool that dictates which readings are sopported for a given MeterMate program todo see link
File B | MeterMate xml
File C | reading types xml (include process to get)
File D | Existing hidden data file
File E | Supported Readings XML
File F | Log file


## Getting Updated Reading Types


This should only be done if there has been an update to the reading types sooner that what is listed in the tool or in `config/hidden_data/ReadingsMap-xxxxxx.json`.

To get updated reading types, you must download an Excel file from Fusion, and convert it to an XML file. The steps to do this are described below.

1. Open the Fusion Item `Y84000-42-DSD | SRFN HEEP ReadingTypeIDs [REV:D]` ([link](https://aclara.autodeskplm360.net/workspace#workspaceid=57&dmsid=5014959))

2. Download `Y84000-42-DSD_ReadingTypeIDsRevD20210414.xlsx`

3. Open the file and navigate the the sheet labeled `READING_TYPE`

4. TODO figure out how to do this


## Getting the Y84000-PTR Tool

This should only be done if you need an updated version of the `Y84000-PTR | SRFN XML Configuration Creation Tool [REV:R]`, which must be imported to properly run the tool. 

1. Open the Fusion Item `Y84000-PTR | SRFN XML Configuration Creation Tool [REV:R]` ([link](https://aclara.autodeskplm360.net/workspace#workspaceid=57&dmsid=5165571&tab=partattachment))

2. Download `Y84000-PTR SRFN XML Configuration Creation Tool RevQ FW _._X V_._.__.__ 20220330Unprotected`, the latest version of `File B todo`


## Getting the MeterMate Program

This should be done every time the tool is run, as this must be imported. 

1. unknown


## Creating the Executable

This is optional and not required for proper use of the application.

To create the executable, the source code must be downloaded to your machine (see [Downloading the Code](#downloading-the-code)), and your present working directory in the command line must be `DCU_Config_Tool/`. 

1. Install [Python (3+)](https://www.python.org/downloads/) and ensure you can open a python interpreter:
```bash
$ py
# Make sure that the below interpreter is opened. If not, download Python using the link above.
Python 3.10.5 (tags/v3.10.5:f377153, Jun  6 2022, 16:14:13) [MSC v.1929 64 bit (AMD64)] on win32
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```
2. Install [pip](https://pip.pypa.io/en/stable/) using the link or these commands:
```bash
$ pip --version
# If the above statement prints a version of pip, ignore the rest of the commands in this chunk
$ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
$ py get-pip.py
$ py -m pip install --upgrade pip
```
3.  Use the pip to install the following modules:

```bash
$ pip install pyinstaller
$ pip install openpyxl
$ pip install xlwings
$ pip install xmlschema
```

4. Once you have installed these modules, run this command and ensure that all three of the above modules are installed and make note of their file location:

```bash
$ pip list -v
...
pyinstaller   5.3     ...\python\python310\lib\site-packages
xmlschema     2.0.1   ...\python\python310\lib\site-packages
openpyxl      3.0.10  ...\python\python310\lib\site-packages
...
```
5. Locate the `app.spec` file. This is the file that `pyinstaller` uses to create an executable. We are going to first fix the paths in this file, then modify the build script. Locate the `Analysis` attribute:

```python
a = Analysis(
    ['<YOUR_SOURCE_PATH>/.../app.py'],
    ...
    datas=[('<YOUR_PYTHON_LIBRARY_PATH>/xmlschema', 'xmlschema/'), 
            ('<YOUR_PYTHON_LIBRARY_PATH>/openpyxl', 'openpyxl/'), 
            ('<YOUR_PYTHON_LIBRARY_PATH>/openpyxl', 'xlwings/'), 
            ('docs/data/SupportedEnums.xsd', 'docs/data/'),
            ('docs/data/READING_TYPE.xsd', 'docs/data/'),
            ('docs/data/MeterMateGenericSchema.xsd', 'docs/data/')]
    ...
```
Find `<YOUR_SOURCE_PATH>`, and replace it the absolute path of where your source directory is located. (If you need help, try running the command `$ pwd`).

Find `<YOUR_PYTHON_LIBRARY_PATH>`, and replace it with the corresponding path from step 4. For example, if the path for **pyinstaller** from step 4 was **"C:\dir\python\python310\lib\site-packages"**, set `<YOUR_PYTHON_LIBRARY_PATH>` to **"C:\dir\python\python310\lib\site-packages\pyinstaller"**

**DO NOT MODIFY ANYTHING ELSE IN `app.spec`**

6. Locate the `buildScript.bat` batch file in the `scripts/` directory. Find Section 1, and initialize the name of your directory from step 5, and the name of the spec file. Section 2 will build the executable, and Section 3 will place the config files in the executable's directory.

7. Run the batch file on your machine:

```bash
$ ./scripts/buildScript.bat # This should take ~20 seconds
```
If an error occurs, contact the owner. 

8. After the executable has been tested or moved somewhere else, to clean all files generated by the process, run the clean script:

```bash
$ ./scripts/cleanScript.bat # Will remove all pyinstaller generated files and __pycache__ files
```

## Contributing

This project lives in an Azure DevOps repository. To clone this repository, you must have [git](https://git-scm.com/download/win) installed on your machine. Once you do, you are now able to clone it.

```bash
git clone https://aclara.visualstudio.com/Product%20Development%20Test/_git/SRFN_Configuration_Auxiliary_Tools
```
I am not exactly sure how permissions work with Aclara's ADO, so I apologize if this does not work.

## Contact

If you want to contact me, feel free to reach me at BSchwartz@hubbell.com

## Licence

This project uses the MIT License.
