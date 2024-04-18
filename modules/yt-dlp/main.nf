process YT_DLP {

    conda "${moduleDir}/environment.yml"

    input:
    val youtube_url

    output:
    path "*.mp4"

    script:
    """
    yt-dlp \\
        --extract-audio \\
        --audio-format mp4 \\
        --output audio.mp4 \\
        $youtube_url
    """
}
