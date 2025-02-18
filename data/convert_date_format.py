import re
import os
import csv

def convert_date_format(date_str):
    # Regex pattern to match the date format
    pattern = r"(\d{1,2})/(\d{1,2})/(\d{4})(?: (\d{1,2}):(\d{1,2}))?"
    match = re.match(pattern, date_str)

    if not match:
        print(date_str)
        raise ValueError(f"Invalid date format: {date_str}")

    month, day, year, hours, minutes = match.groups()

    if hours is None or minutes is None:
        hours = "00"
        minutes = "00"

    # Ensure day and month are two digits
    hours = hours.zfill(2)
    minutes = minutes.zfill(2)
    day = day.zfill(2)
    month = month.zfill(2)

    # Return formatted date
    return f"{year}-{month}-{day} {hours}:{minutes}"


def process_csv(file_path, columns_name):
    # Read the CSV file
    with open(file_path, mode='r', newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        fieldnames = reader.fieldnames
        rows = list(reader)

    # Convert the specified column to the correct format
    for row in rows:
        for column_name in columns_name:
            row[column_name] = convert_date_format(row[column_name])

    # Write the updated rows back to the same CSV file
    with open(file_path, mode='w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

def process_multiple_csv(files_columns):
    for file_path, columns_name in files_columns.items():
        process_csv(file_path, columns_name)

files_columns = {
    os.path.join('..', 'data', 'trip.csv'): ['start_date', 'end_date'],
    os.path.join('..', 'data', 'station.csv'): ['installation_date'],
    os.path.join('..', 'data', 'weather.csv'): ['date']
}

process_multiple_csv(files_columns)