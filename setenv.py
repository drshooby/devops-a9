import os

aws_access_key = input("Enter AWS Access Key ID: ")
aws_secret_key = input("Enter AWS Secret Access Key: ")
aws_session_token = input("Enter AWS Session Token (if applicable): ")

on_windows = input("Are you using Windows? (y/n)...type y or n otherwise assume no: ")
print(f'\nRun the following command in your shell to set AWS credentials:')
if on_windows.lower() == "y":
    print(f'Windows (PowerShell): $env:AWS_ACCESS_KEY_ID="{aws_access_key}"; $env:AWS_SECRET_ACCESS_KEY="{aws_secret_key}"; $env:AWS_SESSION_TOKEN="{aws_session_token}"')
else:
    print(f'Linux/macOS: export AWS_ACCESS_KEY_ID="{aws_access_key}" AWS_SECRET_ACCESS_KEY="{aws_secret_key}" AWS_SESSION_TOKEN="{aws_session_token}"')
