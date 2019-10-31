//
//  ColorCubeTests.swift
//  ColorCubeTests
//
//  Created by muukii on 2016/11/27.
//  Copyright © 2016 muukii. All rights reserved.
//

import XCTest
@testable import ColorCube

class ColorCubeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testExample() {

      let resultData = Bundle(for: ColorCubeTests.self).path(forResource: "LUT", ofType: "cube")
        .flatMap { URL(fileURLWithPath: $0) }
        .flatMap { try? Data(contentsOf: $0) }

      let sampleImage = Bundle(for: ColorCubeTests.self).path(forResource: "IMG_4207", ofType: "jpg")
        .flatMap { URL(fileURLWithPath: $0) }
        .flatMap { try? Data(contentsOf: $0) }
        .flatMap { CIImage.init(data: $0) }

      let image = Bundle(for: ColorCubeTests.self).path(forResource: "LUT", ofType: "png")
        .flatMap { URL(fileURLWithPath: $0) }
        .flatMap { try? Data(contentsOf: $0) }
        .flatMap { UIImage(data: $0) }

//      let dimension = 64
//      let data = ColorCube.cubeData(lutImage: image!, dimension: dimension, colorSpace: CGColorSpaceCreateDeviceRGB())
        let dimension = 33
        let data = ColorCubeTests.readFromLUT(fileName: "/Users/Account/Drink/StikLightAlgo/StikLightAlgo/test_lut.txt", dimension: dimension)
      let filter = CIFilter(name: "CIColorCube", withInputParameters: [
        "inputCubeDimension": dimension,
        "inputCubeData": data,
        "inputImage":sampleImage
        ])!

//      print(filter!.outputImage)
//
//      let o = filter!.outputImage
//
//      XCTAssertEqual(data, resultData)
//
//      print(data)
        let result = filter.outputImage!

        let cgImage = CIContext().createCGImage(result, from: result.extent)
        
        let result_image = UIImage(cgImage: cgImage!)

        let url = NSURL(string: "file:///Users/Account/Documents/result_image.jpg")
        
        do {
            try UIImageJPEGRepresentation(result_image, 1.0)?.write(to: url as! URL)
        } catch let e {
            print(e)
        }
    }
    
    static func readFromLUT(fileName: String, dimension: Int) -> Data? {
        
        //        guard let path = Bundle(for: type(of: self) as! AnyClass).path(forResource: fileName, ofType: "txt") else {
        //            return nil
        //        }
        let dataSize = dimension * dimension * dimension * MemoryLayout<Float>.size * 4
        var rgbArray = Array<Float>(repeating: 0, count: dataSize)
        
        do {
            var i = 0
            let content = try String(contentsOfFile:fileName, encoding: String.Encoding.utf8)
            let rows:[String] = content.components(separatedBy: "\n")
            for row in rows {
                let rgbString:[String] = row.components(separatedBy: " ")
                for rgb in rgbString {
                    // TODO cannot add rgb to array
                    rgbArray.insert(Float(rgb) as! Float, at: i)
                    i += 1
                }
                rgbArray.insert(Float(1.0), at: i)
                i += 1
            }
        } catch _ as NSError {
            print("no file found fuck!")
            return nil
        }
        
        for i in stride(from: 0, to: 1000, by: 1) {
            print(rgbArray[i])
        }
        
        let data = Data.init(bytes: rgbArray, count: dataSize)
        return data
    }
}
