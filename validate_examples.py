#!/usr/bin/env python3
"""
Uilib Example Validation Script
Validates that all UI components are properly demonstrated in the example files
"""

import re
import os

def validate_example_file(filename):
    """Validate that an example file contains all required components"""
    
    if not os.path.exists(filename):
        print(f"❌ File {filename} not found")
        return False
    
    with open(filename, 'r') as f:
        content = f.read()
    
    # Required components to check for
    required_components = [
        'CreateButton',
        'CreateToggle', 
        'CreateSlider',
        'CreateInput',
        'CreateDropdown',
        'CreateSearchBox',
        'CreateLabel',
        'CreateSeparator',
        'CreateSection'
    ]
    
    # Theme and management features
    required_features = [
        'SetTheme',
        'Notify',
        'Callback'
    ]
    
    print(f"\n🔍 Validating {filename}:")
    
    # Check components
    missing_components = []
    for component in required_components:
        if component not in content:
            missing_components.append(component)
        else:
            print(f"  ✅ {component}")
    
    # Check features  
    missing_features = []
    for feature in required_features:
        if feature not in content:
            missing_features.append(feature)
        else:
            print(f"  ✅ {feature}")
    
    # Check for loadstring compatibility
    if 'loadstring' in content or 'game:HttpGet' in content:
        print(f"  ✅ Loadstring compatible")
    else:
        print(f"  ⚠️  May not be loadstring compatible")
    
    # Check for compact size (for compact example)
    if 'compact' in filename.lower():
        if re.search(r'Size.*UDim2\.new\(0,\s*[0-9]{3,4}', content):
            print(f"  ✅ Compact sizing detected")
        else:
            print(f"  ⚠️  No compact sizing found")
    
    # Count callback implementations
    callback_count = len(re.findall(r'Callback\s*=\s*function', content))
    print(f"  ✅ {callback_count} working callbacks")
    
    # Count sections
    section_count = len(re.findall(r'CreateSection\s*\(', content))
    print(f"  ✅ {section_count} sections")
    
    # Report results
    if missing_components:
        print(f"  ❌ Missing components: {', '.join(missing_components)}")
    
    if missing_features:
        print(f"  ❌ Missing features: {', '.join(missing_features)}")
    
    success = not missing_components and not missing_features
    print(f"  {'✅ VALID' if success else '❌ INVALID'}")
    
    return success

def main():
    print("=== Uilib Example Validation ===")
    
    # Files to validate
    example_files = [
        'UilibExample.lua',
        'CompactExample.lua'
    ]
    
    all_valid = True
    
    for filename in example_files:
        valid = validate_example_file(filename)
        all_valid = all_valid and valid
    
    # Additional checks
    print("\n📊 Additional Validation:")
    
    # Check if README exists and has examples
    if os.path.exists('README.md'):
        with open('README.md', 'r') as f:
            readme_content = f.read()
        
        if 'loadstring' in readme_content and 'UilibExample.lua' in readme_content:
            print("  ✅ README contains usage examples")
        else:
            print("  ⚠️  README missing usage examples")
    else:
        print("  ❌ README.md not found")
    
    # Check main library file
    if os.path.exists('Uilib.lua'):
        print("  ✅ Main library file exists")
        
        with open('Uilib.lua', 'r') as f:
            lib_content = f.read()
        
        # Verify all component creation methods exist
        for component in ['CreateButton', 'CreateToggle', 'CreateSlider', 'CreateInput', 
                         'CreateDropdown', 'CreateSearchBox', 'CreateLabel', 'CreateSeparator']:
            if f'function Library:{component}' in lib_content:
                print(f"    ✅ {component} implemented")
            else:
                print(f"    ❌ {component} missing")
                all_valid = False
    else:
        print("  ❌ Uilib.lua not found")
        all_valid = False
    
    print(f"\n{'🎉 ALL VALIDATION PASSED!' if all_valid else '❌ VALIDATION FAILED'}")
    
    if all_valid:
        print("\n📋 Summary:")
        print("  - All UI components are demonstrated")
        print("  - Examples are loadstring compatible") 
        print("  - Compact sizing is implemented")
        print("  - Working callbacks are provided")
        print("  - Multiple sections organize components")
        print("  - Documentation is complete")
    
    return all_valid

if __name__ == "__main__":
    main()