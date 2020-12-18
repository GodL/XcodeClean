
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
        
        let xcpgDevicePath = homePath.appendingPathComponent("XCPGDevices")
        
        let simulatorPath = homePath.appendingPathComponent("CoreSimulator")
        let simulatorDevicePath = simulatorPath.appendingPathComponent("Devices")
        
        print(">>>>>>>>>> Counting the size before cleaning <<<<<<<<<<<")
        let beginXcodeSize = try getDirectorySize(at: xcodePath.path)
        let beginSimulatorSize = try getDirectorySize(at: simulatorPath.path)
        let beginTotal = Double(beginXcodeSize + beginSimulatorSize) / 1024.0 / 1024.0
        
        print(">>>>>>>>>> size: \(beginTotal) MB")
        print(">>>>>>>>>> begin clean <<<<<<<<<<")
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.xclean.GodL", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)

        clean(at: devicePath.path, group: group, queue: queue)
        clean(at: deviceSupportPath.path, group: group, queue: queue)
        clean(at: xcpgDevicePath.path, group: group, queue: queue)
        clean(at: simulatorDevicePath.path, group: group, queue: queue)
        group.wait()
        do {
            let endXcodeSize = try getDirectorySize(at: xcodePath.path)
            let endSimulatorSize = try getDirectorySize(at: simulatorPath.path)
            
            let total = (beginXcodeSize - endXcodeSize) + (beginSimulatorSize - endSimulatorSize)
                        
            print(">>>>>>>>>> It's cleaned up altogether \(Double(total) / 1024.0 / 1024.0) MB <<<<<<<<<<")
        }catch let error {
            print("Statistical error by: \(error)")
        }
    }
    
    func clean(at path: String, group: DispatchGroup, queue: DispatchQueue) {
        guard FileManager.default.fileExists(atPath: path) else {
            print("there are no file at \(path)")
            return
        }
        group.enter()
        queue.async(group: group, qos: .userInitiated, flags: .assignCurrentContext) {
            do {
                print(">>>>>>>>>> cleaning at \(path) <<<<<<<<<<")
                try FileManager.default.removeItem(atPath: path)
                group.leave()
                print(">>>>>>>>>> clean finished \(path) <<<<<<<<<<")
            }catch let error {
                group.leave()
                print(">>>>>>>>>> cleaning failed \(path) with Error: \(error) <<<<<<<<<<")
            }
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
