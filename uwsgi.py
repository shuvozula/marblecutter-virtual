
import logging
from virtual.web import app

logging.basicConfig(level=logging.INFO)
logging.getLogger("rasterio._base").setLevel(logging.WARNING)
LOG = logging.getLogger(__name__)

if __name__ == '__main__':
    app.run()
