import UIKit
import CoreML
import Vision

class ImageBackgroundRemover {

    private let model: VNCoreMLModel

    init?() {
          // Assurez-vous que le nom du fichier modèle correspond exactement au nom du fichier .mlmodelc dans votre bundle d'application.
          guard let modelURL = Bundle.main.url(forResource: "DeepLabV3", withExtension: "mlmodelc") else {
              print("Le modèle ML n'a pas été trouvé dans le bundle.")
              return nil
          }
          print("Chemin du modèle : \(modelURL)")

          // Essayez de charger le modèle VNCoreMLModel à partir du fichier .mlmodelc.
          do {
              // Assurez-vous que DeepLabV3 est le nom correct de la classe générée pour votre modèle Core ML.
              let coreMLModel = try MLModel(contentsOf: modelURL)
              self.model = try VNCoreMLModel(for: coreMLModel)
          } catch {
              print("Erreur lors de la création du modèle VNCoreMLModel : \(error)")
              return nil
          }
      }

}
