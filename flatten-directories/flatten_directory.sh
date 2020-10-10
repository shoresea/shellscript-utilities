#!/bin/bash
helpFunction()
{
   echo ""
   echo "Usage: $0 -s source_directory -d destination_directory"
   echo -e "\t-s Source Directory whose sub-directories and files needs to be flatten/merged"
   echo -e "\t-d Destination Directory where files should be copied"
   exit 1 # Exit script after printing help
}

while getopts s:d: flag
do
    case "${flag}" in
        s) source_directory=${OPTARG};;
        d) destination_directory=${OPTARG};;
        ?) helpFunction ;; # Print helpFunction in case parameter is non-existent
    esac
done

# Print helpFunction in case parameters are empty
if [ -z "$source_directory" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Create default destination directory if -d argument not specified
if [ -z "$destination_directory" ]
then
   echo "Setting destination directory to default ./output";
   destination_directory="./output";
fi

### Check if a source_directory does not exist ###
if [ ! -d "$source_directory" ]
then
    echo "Source Directory $source_directory doesn't exist"
    exit 9999 # die with error code 9999
fi

### Check if a destination_directory does not exist ###
if [ ! -d "$destination_directory" ]
then
    echo "Creating Destination Directory"
    mkdir $destination_directory
fi

echo "Going to flatten $source_directory directory into $destination_directory ..."
tree "$source_directory"

files_list=( $(find "$source_directory" -type f) )
for file in "${files_list[@]}"
do
   echo "File : $file"
   cp "$file" "$destination_directory"
done

echo "Merge Completed! Check $destination_directory directory!"
tree "$destination_directory"
