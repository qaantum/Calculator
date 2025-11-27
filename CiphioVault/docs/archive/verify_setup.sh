#!/bin/bash

# Ciphio Setup Verification Script
# This script helps verify that your development environment is set up correctly.

echo "🔍 Ciphio Setup Verification"
echo "================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track if everything is OK
ALL_OK=true

# Check Android setup
echo "📱 Checking Android setup..."
echo "----------------------------"

# Check if Android folder exists
if [ -d "android" ]; then
    echo -e "${GREEN}✓${NC} Android folder found"
    
    # Check if gradlew exists
    if [ -f "android/gradlew" ]; then
        echo -e "${GREEN}✓${NC} Gradle wrapper found"
        
        # Check if we can run gradle
        cd android
        if ./gradlew tasks > /dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} Gradle is working"
            
            # Check JDK version
            JAVA_VERSION=$(./gradlew -version 2>&1 | grep "JVM:" | awk '{print $2}' | cut -d'.' -f1)
            if [ ! -z "$JAVA_VERSION" ]; then
                if [ "$JAVA_VERSION" -ge 17 ]; then
                    echo -e "${GREEN}✓${NC} JDK version is 17 or higher (found: $JAVA_VERSION)"
                else
                    echo -e "${RED}✗${NC} JDK version is too old (found: $JAVA_VERSION, need: 17+)"
                    ALL_OK=false
                fi
            else
                echo -e "${YELLOW}⚠${NC} Could not determine JDK version"
            fi
        else
            echo -e "${RED}✗${NC} Gradle is not working (may need internet connection for first run)"
            ALL_OK=false
        fi
        cd ..
    else
        echo -e "${RED}✗${NC} Gradle wrapper not found"
        ALL_OK=false
    fi
else
    echo -e "${RED}✗${NC} Android folder not found"
    ALL_OK=false
fi

echo ""

# Check iOS setup
echo "🍎 Checking iOS setup..."
echo "-----------------------"

# Check if iOS folder exists
if [ -d "ios" ]; then
    echo -e "${GREEN}✓${NC} iOS folder found"
    
    # Check if Swift files exist
    SWIFT_FILES=$(find ios -name "*.swift" -not -path "*/CiphioTests/*" | wc -l)
    if [ "$SWIFT_FILES" -gt 0 ]; then
        echo -e "${GREEN}✓${NC} Found $SWIFT_FILES Swift source files"
    else
        echo -e "${YELLOW}⚠${NC} No Swift source files found"
    fi
    
    # Check if test files exist
    TEST_FILES=$(find ios -name "*Tests.swift" | wc -l)
    if [ "$TEST_FILES" -gt 0 ]; then
        echo -e "${GREEN}✓${NC} Found $TEST_FILES test files"
    else
        echo -e "${YELLOW}⚠${NC} No test files found (optional)"
    fi
    
    # Check if we're on macOS (required for iOS development)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${GREEN}✓${NC} Running on macOS (required for iOS development)"
        
        # Check if Xcode is installed
        if command -v xcodebuild &> /dev/null; then
            XCODE_VERSION=$(xcodebuild -version 2>&1 | head -n 1)
            echo -e "${GREEN}✓${NC} Xcode is installed: $XCODE_VERSION"
        else
            echo -e "${YELLOW}⚠${NC} Xcode not found (install from Mac App Store)"
        fi
    else
        echo -e "${YELLOW}⚠${NC} Not running on macOS (iOS development requires macOS)"
    fi
else
    echo -e "${RED}✗${NC} iOS folder not found"
    ALL_OK=false
fi

echo ""

# Check documentation
echo "📚 Checking documentation..."
echo "----------------------------"

DOCS=("README.md" "GETTING_STARTED.md" "PROJECT_SUMMARY.md" "SETUP_CHECKLIST.md")
for doc in "${DOCS[@]}"; do
    if [ -f "$doc" ]; then
        echo -e "${GREEN}✓${NC} $doc found"
    else
        echo -e "${YELLOW}⚠${NC} $doc not found"
    fi
done

echo ""

# Summary
echo "================================"
if [ "$ALL_OK" = true ]; then
    echo -e "${GREEN}✅ Setup looks good!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Read GETTING_STARTED.md for detailed instructions"
    echo "  2. Open Android Studio and open the 'android' folder"
    echo "  3. For iOS, open Xcode and create/open the project"
    echo ""
    echo "Happy coding! 🚀"
else
    echo -e "${RED}❌ Some issues found${NC}"
    echo ""
    echo "Please check the errors above and:"
    echo "  1. Read GETTING_STARTED.md for setup instructions"
    echo "  2. Check SETUP_CHECKLIST.md for verification steps"
    echo "  3. See README.md troubleshooting section"
    echo ""
fi

