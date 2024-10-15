package funkin.utils;



import openfl.filesystem.File;

/**
 * Utility class for working with source code files and directories.
 * Provides methods to calculate Lines of Code (LOC), file count, and project statistics.
 */
class SourceUtil {
    
    /**
     * Calculates the number of lines in a given source string.
     * @param source The source code as a string.
     * @return The number of lines in the source code.
     */
    public static function getLOCFromString(source:String):Int {
        return source.split("\n").length;
    }

    /**
     * Calculates the number of lines in a given file.
     * @param path The path to the file.
     * @return The number of lines in the file.
     * @throws If the file does not exist or is a directory instead of a file.
     */
    public static function getLOCFromFile(path:String):Int {
        var file:File = new File(path);
        if (!file.exists) {
            throw "File does not exist";
        }
        if (file.isDirectory) {
            throw "Supplied path must resolve to a valid text file";
        }

        // Load file contents and calculate the LOC
        file.load();
        var source:String = file.data.toString();
        return getLOCFromString(source);
    }

    /**
     * Recursively calculates the total number of lines of code (LOC) from all valid files 
     * in a directory and its subdirectories. Only files with the specified extensions are included.
     * 
     * @param path The path to the directory.
     * @param fileTypes Optional. A list of file extensions to consider. Defaults to ["hx"].
     * @return The total number of lines of code in all files with the specified extensions.
     * @throws If the directory does not exist or the path does not point to a valid directory.
     */
    public static function getLOCFromDirectory(path:String, ?fileTypes:Array<String>):Int {
        var dir:File = new File(path);
        if (!dir.exists) {
            throw "Directory does not exist";
        }
        if (!dir.isDirectory) {
            throw "Supplied path must resolve to a valid directory";
        }
        if (fileTypes == null) {
            fileTypes = ["hx"];
        }

        // Get the list of files in the directory
        var files:Array<File> = dir.getDirectoryListing();
        var totalLOC:Int = 0;

        // Iterate through each file or subdirectory
        for (file in files) {
            var targetPath:String = file.nativePath;
            if (file.isDirectory) {
                // Recursively calculate LOC for subdirectories
                totalLOC += getLOCFromDirectory(targetPath, fileTypes);
            } else {
                // Only process files with the specified extensions
                if (fileTypes.contains(file.extension)) {
                    totalLOC += getLOCFromFile(targetPath);
                }
            }
        }

        return totalLOC;
    }

    /**
     * Recursively calculates the total number of files in a directory and its subdirectories.
     * Only files with the specified extensions are included.
     * 
     * @param path The path to the directory.
     * @param fileTypes Optional. A list of file extensions to consider. Defaults to ["hx"].
     * @return The total number of files in the directory and its subdirectories.
     * @throws If the directory does not exist or the path does not point to a valid directory.
     */
    public static function getFileCount(path:String, ?fileTypes:Array<String>):Int {
        var dir:File = new File(path);
        if (!dir.exists) {
            throw "Directory does not exist";
        }
        if (!dir.isDirectory) {
            throw "Supplied path must resolve to a valid directory";
        }
        if (fileTypes == null) {
            fileTypes = ["hx"];
        }

        // Get the list of files in the directory
        var files:Array<File> = dir.getDirectoryListing();
        var totalFiles:Int = 0;

        // Iterate through each file or subdirectory
        for (file in files) {
            var targetPath:String = file.nativePath;
            if (file.isDirectory) {
                // Recursively calculate file count for subdirectories
                totalFiles += getFileCount(targetPath, fileTypes);
            } else {
                totalFiles++;
            }
        }

        return totalFiles;
    }

    /**
     * Recursively calculates project statistics, including total LOC, number of files, and total size.
     * 
     * @param path The path to the directory.
     * @param fileTypes Optional. A list of file extensions to consider. Defaults to ["hx"].
     * @return An object containing LOC, file count, and total size (in bytes).
     * @throws If the directory does not exist or the path does not point to a valid directory.
     */
    public static function getProjectStats(path:String, ?fileTypes:Array<String>):{loc:Int, files:Int, size:Int} {
        var dir:File = new File(path);
        if (!dir.exists) {
            throw "Directory does not exist";
        }
        if (!dir.isDirectory) {
            throw "Supplied path must resolve to a valid directory";
        }
        if (fileTypes == null) {
            fileTypes = ["hx"];
        }

        // Get the list of files in the directory
        var files:Array<File> = dir.getDirectoryListing();
        var totalLOC:Int = 0;
        var totalSize:Int = 0;
        var totalFiles:Int = 0;

        // Iterate through each file or subdirectory
        for (file in files) {
            var targetPath:String = file.nativePath;
            if (file.isDirectory) {
                // Recursively calculate stats for subdirectories
                var stats:{loc:Int, files:Int, size:Int} = getProjectStats(targetPath, fileTypes);
                totalLOC += stats.loc;
                totalSize += stats.size;
                totalFiles += stats.files;
            } else {
                if (fileTypes.contains(file.extension)) {
                    totalLOC += getLOCFromFile(targetPath);
                    totalSize += Std.int(file.size);
                    totalFiles++;
                }
            }
        }

        // Return an object containing the LOC, file count, and total size
        return {loc:totalLOC, files:totalFiles, size:totalSize};
    }
}