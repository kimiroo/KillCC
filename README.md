# KillCC
Kills unnecessary Adobe CC Junk Proccesses in one shot.

## Introduction
This batch script kills all of Adobe CC Junk processes in a one shot.
You can edit included DB file or use custom DB file.

## Usage
KillCC.bat [CustomDB]

[CustomDB]: Path to your own custom DB file

Note:
- Path to batch scipt and DB file must not conatin any spaces.
- Path to DB file must not contain any spaces.

## Notes on custom DB file
[Optional] You might want to add following lines to your DB file:
- DBName=[YOUR-DB-NAME]
- DBVer=[YOUR-DB-VERSION]

Note:
- Batch script looks for "KillCC_ProcessDB" for DBName value and will warn if it doesn't match. It will also warn if DBName and DBVer values aren't present.

## Changelogs
2020-07-14: Initial commit

## Notes
I'm planning to convert this project to more powerful python project. Batch files are just pain in the ass for me...
