params.file = ''
params.help = false
params.timestamp = false
params.youtube_url = ''
params.model = 'tiny'
params.outdir = "."

include { YT_DLP } from './modules/yt-dlp'
include { FFMPEG } from './modules/ffmpeg'
include { WHISPERCPP } from './modules/whispercpp'

process PRINT {
  input:
    path transcription
  output:
    stdout
  script:
    """
    cat $transcription
    """
}

workflow {
  // Checks for proper parameter handling
  if (!(new File(params.outdir)).exists()) {
    throw new Exception("The outdir folder must exist")
  } else if (params.help) {
    print """
      Usage: nextflow run main.nf [options]
      Options:
        --file        file   Generate transcription from this audio file
        --help               Print this help message
        --model       model  Set Whisper pre-trained model. Options are: tiny, base, small, medium, large. Default: tiny
        --outdir      path   Path to store transcriptions
        --timestamp          Print timestamps with each speech segment
        --youtube_url URL    Extract audio from this YouTube URL to generate transcription
    """
  } else if (params.youtube_url == '' && params.file == '') {
    throw new Exception("""
    Mandatory parameter missing!
    You failed to provide a valid YouTube URL with --youtube_url
    or an audio file with --file
    For help, run: nextflow run main.nf --help
    """)
  } else if (params.youtube_url != '' && params.file != '') {
    throw new Exception("""
    You can not provide --file and --youtube_url at the same time.
    Choose only one of these options each time.
    For help, run: nextflow run main.nf --help
    """)
  // Checking conditions on how to behave
  } else {
    // If it's a YouTube URL, you must download the video and extract audio
    if (params.youtube_url != '') {
    YT_DLP(params.youtube_url)
    audio_file = YT_DLP.out | FFMPEG
    } else {
      audio_file = params.file
    }

    model_file = file("https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-${params.model}.bin?download=true", checkExists: true)
    if (params.timestamp) {
      WHISPER_W_TIMESTAMP(audio_file, model_file)
      PRINT(WHISPER_W_TIMESTAMP.out).view()
    } else {
      WHISPERCPP(audio_file, model_file)
      PRINT(WHISPERCPP.out).view()
    }
  }
}
