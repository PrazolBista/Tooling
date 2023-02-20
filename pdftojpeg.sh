#!/bin/bash   # This line is known as a shebang, and specifies the interpreter to use to execute the script. In this case, it tells the shell to use the Bash interpreter.

# Check if the input file exists
if [ ! -f "$1" ]; then # This line checks if the input file specified as the first argument to the script exists and is a regular file. The if statement uses the test command, which is also available in the shell as [ (square brackets). The ! operator negates the condition, so the statement is true if the file does not exist or is not a regular file. The $1 variable represents the first argument passed to the script.
  echo "Error: File not found" # This line is executed if the input file check fails, and simply prints an error message to the console.
  exit 1 # This line exits the script with a status code of 1, indicating that an error occurred.
fi

# Convert PDF to PPM image
pdftoppm -jpeg "$1" output # This line uses the pdftoppm command to convert the input PDF file to a PPM image format. The -jpeg option tells pdftoppm to output JPEG format instead of PPM format. The $1 variable represents the first argument passed to the script (i.e. the input PDF file), and output is the name of the output file (without the extension).

# Convert PPM image to JPEG
convert output.jpg # This line uses the convert command (part of the ImageMagick suite) to convert the intermediate PPM image to a JPEG image. The output JPEG file will have the same name as the input PDF file, but with a .jpg extension.

# Clean up intermediate PPM image
rm output.jpg # This line removes the intermediate PPM image file, since it is no longer needed.

echo "Conversion complete" # This line prints a message to the console indicating that the conversion is complete.
