#!/usr/bin/env ruby

SOURCE_ROOT = "../../box2d/Box2D/Box2D"

$ignoredfiles = []
$sourcefiles = []

def ignoreFile(filename, reason)
	print("Ignoring #{filename}: #{reason}\n")
	$ignoredfiles.push("Ignored: #{filename}\nReason: #{reason}\n\n")
end

def addFile(filename)
	print("Adding file '#{filename}'\n")
	char = $sourcefiles.length == 0 ? ':' : '+'
	$sourcefiles.push("LOCAL_SRC_FILES #{char}= " + filename)
end

def processSources()
	print("Looking for sources in #{SOURCE_ROOT}\n")
	Dir.glob(File.join(SOURCE_ROOT, '**/*.cpp')) {
		| filename |
		if File.stat(filename).directory? then
			# Silently ignore
		else
			case File.extname(filename)
			when '.cpp'
				addFile(filename)
			when '.h'
				# Don't care
			else
				ignoreFile(filename, "Unrecognised extension")
			end
		end
	}
end

def writeIterableToFile(filename, data)
	File.open(filename, "w") do |f|
		if data.length == 0 then
			f.puts('')
		else
			data.each {
				| line |
				f.puts(line)
			}
		end
	end
end

def outputSources(fragments)
	print("Writing #{fragments.length} defintions to Box2DSources.mk\n")
	fragments.unshift("# Generated on #{Time.now.getutc}")
	writeIterableToFile("Box2DSources.mk", fragments)
end

def outputIgnored(ignored)
	print("Writing details about #{ignored.length} files to ignored.txt\n")
	writeIterableToFile("ignored.txt", ignored)
end

processSources()
outputSources($sourcefiles)
outputIgnored($ignoredfiles)

print("Finished!\n")