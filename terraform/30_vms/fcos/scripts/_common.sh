verify_sha256() {
    expected_sha256="$1"; shift
    file_path="$1"; shift
    
    echo "${expected_sha256} ${file_path}" | sha256sum -c -
    if [ $? -ne 0 ]; then
        echo "Invalid SHA256 of ${file_path}"
        exit 2
    fi
}