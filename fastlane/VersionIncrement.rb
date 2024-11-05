def android_increment_my_version_code_and_name
  build_gradle_path = "../android/app/build.gradle"

  build_gradle = File.read(build_gradle_path)

  version_code = build_gradle.match(/versionCode\s+(\d+)/)[1].to_i
  version_name = build_gradle.match(/versionName\s+"(\d+\.\d+\.\d+)"/)[1]

  major, minor, patch = version_name.split(".").map(&:to_i)

  patch += 1
  if patch == 10
    patch = 0
    minor += 1
  end
  if minor == 10
    minor = 0
    major += 1
  end

  new_version_code = version_code + 1
  new_version_name = "#{major}.#{minor}.#{patch}"

  new_build_gradle = build_gradle.gsub(/versionCode\s+\d+/, "versionCode #{new_version_code}")
  new_build_gradle = new_build_gradle.gsub(/versionName\s+\"\d+\.\d+\.\d+\"/, "versionName \"#{new_version_name}\"")

  File.write(build_gradle_path, new_build_gradle)

end

