# FileFind - Bash Search Script

## Description
`FileFind` is a simple Bash script that allows you to search for files anywhere on your system and optionally search for text patterns inside those files. All results are stored in timestamped logs inside a `searchlogs/` folder.

---

## Features
- Search for any file by name.
- Search for a text pattern inside the found file(s).
- Automatically creates a `searchlogs/` folder for saving results.
- Timestamped logs to avoid overwriting previous searches.
- Displays search results after completion.
- Alerts if the file or pattern is not found.

---

## Usage

1. Make the script executable:
```bash
chmod +x filefind.sh
