
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
        let beginXgpgSize = try getDirectorySize(at: xcpgDevicePath.path)
        let beginSimulatorSize = try getDirectorySize(at: simulatorPath.path)
        let beginTotal = Double(beginXcodeSize + beginXgpgSize + beginSimulatorSize) / 1024.0 / 1024.0
        
        print(">>>>>>>>>> size: \(beginTotal) MB")
        print(">>>>>>>>>> begin clean <<<<<<<<<<")
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.xclean.GodL", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)

        try clean(at: devicePath.path, group: group, queue: queue)
        try clean(at: deviceSupportPath.path, group: group, queue: queue)
        try clean(at: xcpgDevicePath.path, group: group, queue: queue)
        try clean(at: simulatorDevicePath.path, group: group, queue: queue)
        group.wait()
        do {
            let endXcodeSize = try getDirectorySize(at: xcodePath.path)
            let endXcpgSize = try getDirectorySize(at: xcpgDevicePath.path)
            let endSimulatorSize = try getDirectorySize(at: simulatorPath.path)
            
            let total = (beginXcodeSize - endXcodeSize) + (beginSimulatorSize - endSimulatorSize) + (beginXgpgSize - endXcpgSize)
                        
            print(">>>>>>>>>> It's cleaned up altogether \(Double(total) / 1024.0 / 1024.0) MB <<<<<<<<<<")
        }catch let error {
            print("Statistical error by: \(error)")
        }
    }
    
    func clean(at path: String, group: DispatchGroup, queue: DispatchQueue) throws {
        guard FileManager.default.fileExists(atPath: path) else {
            print("there are no file at \(path)")
            return
        }
        try FileManager.default.contentsOfDirectory(atPath: path).forEach {
            let subPath = path + "/" + $0
            group.enter()
            queue.async(group: group, execute: DispatchWorkItem(block: {
                do {
                    print(">>>>>>>>>> cleaning at \(subPath) <<<<<<<<<<")
                    try FileManager.default.removeItem(atPath: subPath)
                    group.leave()
                    print(">>>>>>>>>> clean finished \(subPath) <<<<<<<<<<")
                }catch let error {
                    group.leave()
                    print(">>>>>>>>>> cleaning failed \(subPath) with Error: \(error) <<<<<<<<<<")
                }
            }))
        }
    }
    
    func getDirectorySize(at directory: String) throws -> UInt64 {
        guard FileManager.default.fileExists(atPath: directory) else {
            return 0
        }
        var size: UInt64 = 0
        try FileManager.default.subpathsOfDirectory(atPath: directory).forEach {
            let subSize = (try FileManager.default.attributesOfItem(atPath: directory.appending("/\($0)")) as NSDictionary).fileSize()
            size += subSize
        }
        return size
    }

}

Clean.main()
