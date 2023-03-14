# Imports the Google Cloud client library
from google.cloud import speech


# Instantiates a client
client = speech.SpeechClient().from_service_account_file('key.json')

# The name of the audio file to transcribe
gcs_uri = "touslesaudios/audioseb.wav"

#export GOOGLE_APPLICATION_CREDENTIALS="key.json"

with open(gcs_uri, 'rb') as audio_file:
    content = audio_file.read()


def transcribe_speech():
    
    audio = speech.RecognitionAudio(content=content)

    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=48000,
        language_code="fr",
    )

    # Detects speech in the audio file
    response = client.recognize(config=config, audio=audio)

    for result in response.results:
        print("Transcript: {}".format(result.alternatives[0].transcript))


# Tets function
transcribe_speech()