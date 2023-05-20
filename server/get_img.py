from PIL import Image
import requests
from io import BytesIO
import numpy as np

url = 'http://<your-ip>:8888/get_graph'

params = {
    'x': np.arange(5),
    'y': 5*np.arange(5),
    'approx': 'linear',
}
response = requests.get(url=url, params=params)
img = Image.open(BytesIO(response.content))
img.save("graphic.png")
