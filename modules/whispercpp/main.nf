// TODO https://github.com/ggerganov/whisper.cpp/blob/master/examples/yt-wsp.sh
process WHISPERCPP {

  input:
  path audio_file
  path model

  output:
  path 'transcription.txt'

  script:
  """
  whisper \\
      -t ${task.cpus} \\
      -m ${model} \\
      -f $audio_file \\
      --output-txt \\
      --output-file transcription \\
      --no-timestamps
  """
}
