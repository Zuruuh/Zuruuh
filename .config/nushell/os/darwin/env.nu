$env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/sbin')

$env.SDKROOT = '/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk'
$env.MACOSX_DEPLOYMENT_TARGET = '13.4'
$env.PYTHON_CONFIGURE_OPTS = '--enable-framework'
