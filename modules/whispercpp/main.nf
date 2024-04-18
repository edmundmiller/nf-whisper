// TODO https://github.com/ggerganov/whisper.cpp/blob/master/examples/yt-wsp.sh
process WHISPERCPP {

  container 'ghcr.io/ggerganov/whisper.cpp:main'

  input:
  path audio_file
  val model

  output:
  path 'transcription.txt'

  script:
  """
  ./main \\
    -t ${task.threads} \\
    -m ${model} \\
    -f $audio_file \\
    --output-txt \\
    --no-timestamps
  """
}
