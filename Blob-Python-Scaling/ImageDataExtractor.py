import logging

import azure.functions as func


def processFile(myblob: func.InputStream):
    logging.info(f"Python blob trigger function processed blob \n"
                 f"Name: {myblob.name}\n"
                 f"Blob Size: {myblob.length} bytes")
    body = myblob.read()
    logging.info(" +++++++ Contents in the file: " + str(body))
