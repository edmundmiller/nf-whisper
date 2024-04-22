process FFMPEG {

    conda "${moduleDir}/environment.yml"

    input:
    path audio_file

    output:
    path "output.wav"

    script:
    """
    ffmpeg \\
        -i $audio_file \\
        -ar 16000 \\
        -ac 1 \\
        -c:a pcm_s16le \\
        output.wav
    """
}
