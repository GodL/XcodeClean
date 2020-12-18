
import ArgumentParser
import Foundation
import Dispatch

struct Clean: ParsableCommand {
    
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "xclean")
    
    func run() throws {
        
        var homePath = FileManager.default.homeDirectoryForCurrentUser
 
        homePath.appendPathComponent("Library/Developer")
        let xcodePath = homePath.appendingPathComponent("Xcode")
        let devicePath = xcodePath.appendingPathComponent("DerivedData")
        let deviceSupportPath = xcodePath.appendingPathComponent("iOS DeviceSupport")

        let simulatorPath = homePath.appendingPathComponent("CoreSimulator")
        let simulatorDevicePath = simulatorPath.appendingPathComponent("Devices")
        
        print(">>>>>>>>>> Counting the size before cleaning <<<<<<<<<<<")
        let beginXcodeSize = try getDirectorySize(at: xcodePath.path)
        let beginSimulatorSize = try getDirectorySize(at: simulatorPath.path)
        let beginTotal = Double(beginXcodeSize + beginSimulatorSize) / 1024.0 / 1024.0
        
        print(">>>>>>>>>> size: \(beginTotal) MB")
        print(">>>>>>>>>> begin clean <<<<<<<<<<")

        clean(at: devicePath.path)
        try FileManager.default.contentsOfDirectory(atPath: deviceSupportPath.path).dropFirst().forEach {
            clean(at: deviceSupportPath.path.appending("/\($0)"))
        }
        
        try FileManager.default.contentsOfDirectory(atPath: simulatorDevicePath.path).dropFirst().forEach {
            clean(at: simulatorDevicePath.path.appending("/\($0)"))
        }
        
        
        do {
            let endXcodeSize = try getDirectorySize(at: xcodePath.path)
            let endSimulatorSize = try getDirectorySize(at: simulatorPath.path)
            
            let total = (beginXcodeSize - endXcodeSize) + (beginSimulatorSize - endSimulatorSize)
                        
            print(">>>>>>>>>> It's cleaned up altogether \(Double(total) / 1024.0 / 1024.0) MB <<<<<<<<<<")
        }catch let error {
            print("Statistical error by: \(error)")
        }
    }
    
    func clean(at path: String) {
        do {
            print(">>>>>>>>>> cleaning at \(path) <<<<<<<<<<")
            try FileManager.default.removeItem(atPath: path)
            print(">>>>>>>>>> clean finished \(path) <<<<<<<<<<")
        }catch let error {
            print(">>>>>>>>>> cleaning failed \(path) with Error: \(error) <<<<<<<<<<")
        }
    }
    
    func getDirectorySize(at directory: String) throws -> UInt64 {
        var size: UInt64 = 0
        try FileManager.default.subpathsOfDirectory(atPath: directory).forEach {
            let subSize = (try FileManager.default.attributesOfItem(atPath: directory.appending("/\($0)")) as NSDictionary).fileSize()
            size += subSize
        }
        return size
    }

}

Clean.main()
