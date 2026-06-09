import os
import re
import requests
from urllib.parse import unquote

def download_and_process_sheet(sheet_id):
    url = f"https://docs.google.com/spreadsheets/d/{sheet_id}/export?format=csv"
    
    try:
        response = requests.get(url)
        response.raise_for_status()
        
        content_disposition = response.headers.get('content-disposition', '')
        filename = unquote(content_disposition.split('filename="')[1].split('"')[0])
        
        # Remove "-Sheet1" and add space between words
        base_name = filename.replace("-Sheet1", "")
        clean_name = re.sub(r'(?<=[a-z])(?=[A-Z])', ' ', base_name)
        
        dest_dir = r"C:\Users\alexd\Documents\GitHub\rev-sharer\localization"
        dest_path = os.path.join(dest_dir, clean_name)
        
        os.makedirs(dest_dir, exist_ok=True)
        
        with open(dest_path, 'wb') as f:
            f.write(response.content)
            
        print(f"File successfully saved as: {dest_path}")
        return True

    except Exception as e:
        print(f"Error: {str(e)}")
        return False

# Replace with your actual sheet ID
SHEET_ID = "1Cl-Irop3nGB92qFc9vUx9fXTQgp6Wza0Q4u0lK4IKU0"
download_and_process_sheet(SHEET_ID)
