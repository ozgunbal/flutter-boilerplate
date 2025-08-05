#!/bin/bash

# OpenAPI Generator Script for Dart-Dio
# This script downloads and runs openapi-generator-cli without requiring Node.js

set -e

# Configuration
GENERATOR_VERSION="7.2.0"
GENERATOR_JAR="openapi-generator-cli-${GENERATOR_VERSION}.jar"
GENERATOR_URL="https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/${GENERATOR_VERSION}/${GENERATOR_JAR}"
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPTS_DIR")"
GENERATOR_PATH="${SCRIPTS_DIR}/${GENERATOR_JAR}"

# Default values
INPUT_SPEC="${PROJECT_ROOT}/api/openapi.json"
OUTPUT_DIR="${PROJECT_ROOT}/lib/api/generated"
PACKAGE_NAME="api_client"
CONFIG_FILE="${PROJECT_ROOT}/api/openapi-config.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -i, --input SPEC      Input OpenAPI specification file (default: ${INPUT_SPEC})"
    echo "  -o, --output DIR      Output directory (default: ${OUTPUT_DIR})"
    echo "  -p, --package NAME    Package name (default: ${PACKAGE_NAME})"
    echo "  -c, --config FILE     Configuration file (default: ${CONFIG_FILE})"
    echo "  --clean               Clean output directory before generation"
    echo "  --download-only       Only download the generator JAR"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Generate with default settings"
    echo "  $0 -i api/my-spec.yaml -o lib/api    # Custom input and output"
    echo "  $0 --clean                           # Clean and regenerate"
    echo "  $0 --download-only                   # Only download generator"
}

# Function to check if Java is installed
check_java() {
    if ! command -v java &> /dev/null; then
        print_error "Java is not installed or not in PATH"
        print_info "Please install Java 8 or higher to run openapi-generator-cli"
        exit 1
    fi
    
    java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    print_info "Using Java version: ${java_version}"
}

# Function to download openapi-generator-cli JAR
download_generator() {
    if [[ -f "$GENERATOR_PATH" ]]; then
        print_info "Generator JAR already exists: ${GENERATOR_PATH}"
        return 0
    fi
    
    print_info "Downloading openapi-generator-cli ${GENERATOR_VERSION}..."
    print_info "URL: ${GENERATOR_URL}"
    
    # Create scripts directory if it doesn't exist
    mkdir -p "$SCRIPTS_DIR"
    
    if command -v curl &> /dev/null; then
        curl -L -o "$GENERATOR_PATH" "$GENERATOR_URL"
    elif command -v wget &> /dev/null; then
        wget -O "$GENERATOR_PATH" "$GENERATOR_URL"
    else
        print_error "Neither curl nor wget is available"
        print_info "Please install curl or wget to download the generator"
        exit 1
    fi
    
    if [[ -f "$GENERATOR_PATH" ]]; then
        print_success "Downloaded generator JAR to: ${GENERATOR_PATH}"
    else
        print_error "Failed to download generator JAR"
        exit 1
    fi
}

# Function to create default config if it doesn't exist
create_default_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_info "Creating default configuration file: ${CONFIG_FILE}"
        mkdir -p "$(dirname "$CONFIG_FILE")"
        cat > "$CONFIG_FILE" << EOF
{
  "pubName": "${PACKAGE_NAME}",
  "pubVersion": "1.0.0",
  "pubDescription": "Generated API client",
  "pubAuthor": "OpenAPI Generator",
  "pubAuthorEmail": "team@openapitools.org",
  "pubHomepage": "https://github.com/OpenAPITools/openapi-generator",
  "useEnumExtension": true,
  "enumUnknownDefaultCase": true,
  "serializationLibrary": "built_value"
}
EOF
        print_success "Created default configuration file"
    fi
}

# Function to generate API client
generate_api() {
    print_info "Generating Dart-Dio API client..."
    print_info "Input spec: ${INPUT_SPEC}"
    print_info "Output directory: ${OUTPUT_DIR}"
    print_info "Package name: ${PACKAGE_NAME}"
    print_info "Config file: ${CONFIG_FILE}"
    
    # Check if input spec exists
    if [[ ! -f "$INPUT_SPEC" ]]; then
        print_error "Input specification file not found: ${INPUT_SPEC}"
        print_info "Please create an OpenAPI specification file or specify a different path with -i"
        exit 1
    fi
    
    # Create output directory
    mkdir -p "$OUTPUT_DIR"
    
    # Clean output directory if requested
    if [[ "$CLEAN_OUTPUT" == "true" ]]; then
        print_warning "Cleaning output directory: ${OUTPUT_DIR}"
        rm -rf "${OUTPUT_DIR:?}"/*
    fi
    
    # Generate API client
    java -jar "$GENERATOR_PATH" generate \
        -i "$INPUT_SPEC" \
        -g dart-dio \
        -o "$OUTPUT_DIR" \
        -c "$CONFIG_FILE" \
        --additional-properties=pubName="$PACKAGE_NAME" \
        --skip-validate-spec
    
    print_success "API client generated successfully!"
    print_info "Generated files are in: ${OUTPUT_DIR}"
    print_info "Don't forget to run 'flutter pub get' to install dependencies"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--input)
            INPUT_SPEC="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -p|--package)
            PACKAGE_NAME="$2"
            shift 2
            ;;
        -c|--config)
            CONFIG_FILE="$2"
            shift 2
            ;;
        --clean)
            CLEAN_OUTPUT="true"
            shift
            ;;
        --download-only)
            DOWNLOAD_ONLY="true"
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Main execution
print_info "OpenAPI Generator for Dart-Dio"
print_info "Project root: ${PROJECT_ROOT}"

check_java
download_generator

if [[ "$DOWNLOAD_ONLY" == "true" ]]; then
    print_success "Download completed. Generator is ready to use."
    exit 0
fi

create_default_config
generate_api

print_success "All done! 🎉"