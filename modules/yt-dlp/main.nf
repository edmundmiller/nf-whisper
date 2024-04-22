process YT_DLP {

    conda "${moduleDir}/environment.yml"

    input:
    val youtube_url

    output:
    path "*.wav"

    script:
    """
    yt-dlp \\
        --extract-audio \\
        --audio-format wav \\
        --audio-quality 16K \\
        --output audio.wav \\
        $youtube_url
    """
}
