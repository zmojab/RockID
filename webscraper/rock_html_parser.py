import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from bs4 import BeautifulSoup
import requests
import time

def get_infobox(rock_name):
    S = requests.Session()

    URL = "https://en.wikipedia.org/w/api.php"

    SEARCHPAGE = rock_name

    PARAMS = {
        "action": "parse",
        "page": SEARCHPAGE,
        "format": "json",
        "prop": "text",
        "contentmodel": "wikitext"
    }

    R = S.get(url=URL, params=PARAMS)

    # If the request was not successful, print an error message and return
    if R.status_code != 200:
        print(f'Request for {rock_name} failed with status code {R.status_code}')
        return

    DATA = R.json()

    # If the page does not exist, print an error message and return
    if 'parse' not in DATA:
        print(f'No page found for {rock_name}')
        data_dict = {
            'Category': 'N/A',
            'Formula': 'N/A',
            'Crystal system': 'N/A',
            'Mohs scale hardness': 'N/A',
            'Luster': 'N/A',
            'Streak': 'N/A'
            # Add other fields with default values if needed
        }
    else:
        raw_html = DATA["parse"]["text"]["*"]

        soup = BeautifulSoup(raw_html, 'html.parser')

        infobox = soup.find('table', {'class': 'infobox'})  # Find the Infobox

        if infobox is None:
            print(f'No infobox found for {rock_name}')
            return

        rows = infobox.find_all('tr')  # Find all table rows in the Infobox

        desired_headers = ['Category', 'Formula', 'Crystal system', 'Mohs scale hardness', 'Luster', 'Streak']

        data_dict = {}

        for row in rows:
            header = row.find('th')
            data = row.find('td')
            if header:
                a_tag = header.find('a')
                if a_tag:
                    header = a_tag.text
                else:
                    header = header.text
            if header and data and header.strip() in desired_headers:
                data_dict[header.strip()] = data.text.strip()

        print(data_dict)

        doc_ref_old = db.collection('rock information').document(rock_name)
        doc = doc_ref_old.get()
        if doc.exists:
            # Merge the new data with the existing data
            existing_data = doc.to_dict()
            existing_data.update(data_dict)
            data_dict = existing_data

        doc_ref_new = db.collection('rock_information').document(rock_name)
        doc_ref_new.set(data_dict)

# Use a service account
cred = credentials.Certificate("serviceAccount.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

# List of rock names, replace with your actual list of rock names
rock_names = [
    'Alexandrite',
    'Almandine',
    'Amazonite',
    'Amber',
    'Amethyst',
    'Ametrine',
    'Andalusite',
    'Andradite',
    'Aquamarine',
    'Aventurine Green',
    'Aventurine Yellow',
    'Benitoite',
    'Beryl Golden',
    'Bixbite',
    'Bloodstone',
    'Cats Eye',
    'Chalcedony Blue',
    'Chrome Diopside',
    'Chrysoberyl',
    'Chrysocolla',
    'Chrysoprase',
    'Citrine',
    'Coral',
    'Danburite',
    'Diamond',
    'Diaspore',
    'Dumortierite',
    'Emerald',
    'Fluorite',
    'Garnet Red',
    'Goshenite',
    'Grossular',
    'Hessonite',
    'Hiddenite',
    'Iolite',
    'Jade',
    'Kunzite',
    'Kyanite',
    'Labradorite',
    'Lapis Lazuli',
    'Larimar',
    'Malachite',
    'Moonstone',
    'Morganite',
    'Onyx Black',
    'Opal',
    'Pearl',
    'Peridot',
    'Pyrite',
    'Pyrope',
    'Quartz Smoky',
    'Rhodochrosite',
    'Rhodolite',
    'Rhodonite',
    'Ruby',
    'Sapphire',
    'Serpentine',
    'Sodalite',
    'Spessartite',
    'Sphene',
    'Sunstone',
    'Tanzanite',
    'Tigers Eye',
    'Topaz',
    'Tourmaline',
    'Tsavorite',
    'Turquoise',
    'Variscite',
    'Zircon',
    'Zoisite',
    'Agate',
    'Basalt',
    'Coal',
    'Limestone',
    'Quartzite',
    'Sandstone',
    'Granite'
]

for rock in rock_names:
    get_infobox(rock)
    time.sleep(1)
