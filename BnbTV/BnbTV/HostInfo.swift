import Foundation

struct HostInfo: Decodable {
    struct Wifi: Decodable {
        let name: String
        let password: String
    }
    struct Guides: Decodable {
        struct Instruction: Decodable, Identifiable {
            let item: String
            let direction: String
            var id: String { item }
        }
        let instructions: [Instruction]
    }
    struct Rules: Decodable {
        let checkOutTime: String
        let smokingPolicy: String
        let petRules: String
        let cleaningExpectations: String
    }
    struct Property: Decodable {
        let parkingDetails: String
        let extraTowelsLocation: String
        let trashRules: String
        let fireExtinguisherLocation: String
        let trashCollection: String
        let whereToLeaveKeys: String
        let linensAndTowels: String
    }
    struct Contacts: Decodable {
        let primary: String
        let emergency: String
    }
    struct Local: Decodable {
        let recommendations: String
        let hiddenGems: String
    }

    let tvCode: String
    let welcomeMessage: String
    let location: String
    let contactInfo: String
    let wifi: Wifi
    let guides: Guides
    let rules: Rules
    let property: Property
    let contacts: Contacts
    let local: Local
    let generatedAt: String
}
