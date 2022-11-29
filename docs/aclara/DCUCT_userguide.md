# DCU Configuration - XML Creation Tool

This simple application will allow a user to input certain fields and import frequencies to generate a `DCU2+XLS.xml` file.

# Notice

THIS TOOL IS INCOMPLETE, AND HAS MANY OTHER FEATURES THAT NEED TO BE ADDED. THIS IS BEING RELEASED TO GET PEOPLE FAMILIAR WITH THE TOOL, AND TO GET FEEDBACK ON WHAT NEEDS TO BE ADDED.

## Other Notice

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

This tool attempts to simplify the process of taking FCC licensed frequencies and creating a `DCU2+XLS.xml` file.

To accomplish this, the tool must first ingest the assigned frequencies (weather it be from a .csv or .xlsx file), then fill out the customer worksheet. If everything goes smoothly, the tool will produce a `DCU2+XLS.xml` file.

## **Usage**

Before using the tool, you must have:

1. The executable and `config/` directory be located in the same folder on your machine.
2. The `config/` directory contains `config.json` and `hidden_data/` and are well formed, if they were modified (see [Setup](#setup))

**Once you are positive that you have completed the [Setup](#setup) section correctly, open the executable.**

After opening the tool, you will be prompted with a place to import a frequency file, as well as a customer worksheet. Before proceeding, you must complete two tasks:

1. **Import a frequency file**. Once you have obtained a frequency file (see [Getting the Frequency File](#getting-the-frequency-file)), simply click the button and import it.

2. **Fill out the customer worksheet**. This is a form that is used for calculations, and must be filled out correctly. If you have a previous customer worksheet .json from using the tool before, simply click `Upload Entries` in the filemenu.

Once these are completed, you are now ready to generate the `DCU2+XLS.xml` file. To do this, simply click the `Calculate & Export` button.

You may be prompted with warnings, read them carefully. For any errors experienced during runtime, see [Handling Errors](#handling-errors).

You will be prompted with the opportunity to export the generated `DCU2+XLS.xml` file. If you do not want to export the file, simply click `Cancel`. If you want to archive everything the tool did in the current session, click `Archive`.

That's about it.

## Setup

For the application to be run properly, the location of the executable **must** have the structure below. Note that the `hidden_data/` folder is required.

If you are curious about the contents of the `hidden_data/` folder, basically it holds data necessay to create the customer worksheet and the DCU XML. 

```
├── DCU2+XLS XML Generator.exe
└── config/
    ├── config.json
    ├── log.txt (OPTIONAL)
    └── hidden_data/ 
        ├── DCU2+XLS_TEMPLATE.xml
        ├── DCU2+XLS.xsd
        ├── location_data.json
        └── timezone_data.json
```

Please see the below section to determine if you need to make changes to `config.json`, which must be in the same directory as the executable.

### `config.json`

The following does not need to be modified to properly run the program, but must be changed if:

- The sheet name of the excel file that contains frequencies is changed
- The user wants to change the default country shown
- The names of the hidden_data files change
- There is a change to the names of keys in the frequency file
- There is a change to the displayed entry fields
- There is a change to the entry fields that have dropdown options

If one of these is true, locate the `config.json` file in the  `config/` directory, and ensure these fields are set correctly:

```python
'log_mode' # If you want to save the log of calculations
'runtime_log_path' # Where the log calculations will be written to

'FREQ_SHEET_NAME' # The name of the sheet that holds frequency data, if the user opts to load frequencies from an Excel workbook

'FREQUENCY_ENTRY_KEY_NAMES' # The names of the keys corresponding to the imported frequency csv/xlsx file. If these are different in the frequency file that will be imported, change them here

'FCC_FREQUENCY_ENTRY_KEY_NAMES' # Ignore this for now

'dcu_xls_schema_fn' # The name of the schema file that will be used to validate the generated DCU2+XLS.xml file. This must be in the hidden_data folder
'dcu_xls_template_fn' # The name of the template file that will be used to generate the DCU2+XLS.xml file. This must be in the hidden_data folder
'location_data_fn' # The name of the file that holds the location data for the customer worksheet. This must be in the hidden_data folder
'timezone_data_fn' # The name of the file that holds the timezone data for the customer worksheet. This must be in the hidden_data folder

'entries' # A list of entry fields that will be shown on the screen. Each entry field has the following properties:
    - 'name' # Name of the entry shown on the screen
    - 'type' # Weather it's a string/number entry, a checkbox, or a dropdown
    - 'editable' # Weather or not the user may edit the field
    - 'required' # Weather or not the field is required to perform calculations
    - 'comment' # An optional field that will indicate the message displayed if the user clicks on the entry's info button
'default_country' # The country displayed in the entry field at startup
'dropdown_options' # A map where the keys correspond to entry fields that have dropdown options, and values indicating what the dropdown options are. If the options are defined in another file, it is set to null.
```

## **Getting the Frequency File**

This outlines how to acquire a frequency file that will be imported into the tool.

1. TODO

## **Handling Errors**

During the execution of the program, there are several instances where an error can occur. Here is a list of potential errors, and steps to take to possibly fix them.

- **Config error** - The application cannot find the config files. Please ensure that the `config/` directory is in the same directory as the executable and contains `options.json` and `wkst_config.json`, and are well formed, if they were modified (see [Setup](#setup) and [Additional Setup](#additional-setup)).

- **Config error** - The application cannot find the source directory or the default entry/frequency directorys. This is not a fatal error, but will prevent the application from using the present working directory and it's own entry/frequency default data.

- **Invalid data format** - One of the imported files (entries or frequencies) is not formatted correctly. The entry file should be a dictionary, and the frequency file should be a list of frequency dictionary objects.

- **Invalid key name** - In the entry or frequency file, there is an unrecognized key name. Ensure that the imported file key's correspond to the keys indicated in the wkst_config.json file.

- **Incompatible data** - In the entry file, a specified value has an unexpected type. Ensure that the value types in the entry file match those indicated in the wkst_config.json file.

- **Bad frequency data** - During the proccessing of the frequency file, either the data is formatted incorrectly, a required key was not found, or an unexpected value type was parsed. Check the format of the imported frequency file, and the required keys in the wkst_config.json file. If a spreadsheet is being used, make sure that the headers are in row A, and each row below is a frequency object that has all required keys set.

- **Invalid entries** - When not all required entry fields have been properly specified. Ensure that all entry fields have the correct value, and attempt to calculate again.

- **Invalid entry** - When the data entered for a specific entry is invalid, usually when a number-only entry has non-numbers entered into it. Ensure that the data being entered matches the type specified in the wkst_config.json file, and try again.

- **Calculation error** - When there is an error during calculations, usually when a non-sensible set of user entries is used during calculation. This is the most difficult error to fix. Try turing on the log_mode option in the options.json file, and specify the .txt file that the log will be written to. In the log file, it will contain all of the step calculations up to the point where the error occurred. If the bug is still not apparent, inspect the code for that specific step to ensure that the calculations match up with the Excel tool. 

- **Config Status error** - When the calculated status of the configuration is not good enough to safely export the DCU .xml file. Check the status message provided for further instruction.

- **Export error** - When there is an error during the conversion of the template to a data structure so that the calculations can be loaded into it and transferred back to an .xml. Chack the message, ensure that the schema and template have been correctly specified in the options.json file, and that the key names in the template xml match those found in the getXMLstr() function of calculator.py.

- **Fatal error** - Sometime during the execution of the program, an error occurs that is not handled by the program. This is usually due to a bug in the code. Check the log file for the error message, and contact the developer for further assistance.

For any unfixable errors, please contact the developer for further assistance.

## **Contributing**

TBD, a correct git repository still needs to be decided

## **Contact**

If you want to contact me, you can reach me at BSchwartz@hubbell.com

## **Licence**

This project uses the MIT License.