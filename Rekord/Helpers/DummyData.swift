//
//  DummyData.swift
//  Rekord
//
//  Created by Peter Lee on 12/08/21.
//

import Foundation

func generateDummyData(){
    let userDefaults = UserDefaults()
    
    if userDefaults.bool(forKey: "isDummy") == false{
        userDefaults.setValue(true, forKey: "isDummy")
    //MARK: -dummy partner
//    PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "1", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .customer, name: "Panjul", phone: "6281288540387", status: .active, airtableId: "1", address: "Jalan rusun apron", email: "julius@lixus.id", ownerName: "Julius")) { Result in
//        if Result.idPartner != "" || Result.idPartner != nil {
//            print("save 1")
//            DispatchQueue.main.async {
//                
//            
//            }
//            PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "2", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Ricky", phone: "62812885584", status: .active, airtableId: "2", address: "Jalan rusun apron", email: "ricky@abc.com", ownerName: "Ricky")) { Result in
//                if Result.idPartner != "" || Result.idPartner != nil {
//                    print("save 2")
//                    DispatchQueue.main.async {
//                        
//                    
//                    }
//                    PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "3", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .customer, name: "Rico", phone: "62812646464", status: .active, airtableId: "3", address: "Jalan rusun apron", email: "abc@abc.com", ownerName: "Rico")) { Result in
//                        if Result.idPartner != "" || Result.idPartner != nil {
//                            print("save 3")
//                            DispatchQueue.main.async {
//                                
//                            
//                            }
//                            PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "4", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Peter", phone: "62817271726", status: .active, airtableId: "4", address: "Jalan rusun apron", email: "def@def.com", ownerName: "Peter")) { Result in
//                                if Result.idPartner != "" || Result.idPartner != nil {
//                                    print("save 4")
//                                    DispatchQueue.main.async {
//                                        
//                                    
//                                    }
//                                    PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "5", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Valdo", phone: "62811227722", status: .active, airtableId: "5", address: "Jalan rusun apron", email: "efg@efg.com", ownerName: "Valdo")) { Result in
//                                        print("save 5")
//                                        print("added partner")
//                                    }
//                                } else {
//                                    print("error save")
//                                }
//                               
//                            }
//                        } else {
//                            print("error save")
//                        }
//                    }
//                } else {
//                    print("error save")
//                }
//                
//            }
//        } else {
//            print("error save")
//        }
//        
//    }
//        PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "2", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Ricky", phone: "62812885584", status: .active, airtableId: "2", address: "Jalan rusun apron", email: "ricky@abc.com", ownerName: "Ricky")) { Result in
//            if Result.idPartner != "" || Result.idPartner != nil {
//                print("save 2")
//                DispatchQueue.main.async {
//
//
//                }
//            } else {
//                print("error save")
//            }
//
//        }
//        PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "3", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .customer, name: "Rico", phone: "62812646464", status: .active, airtableId: "3", address: "Jalan rusun apron", email: "abc@abc.com", ownerName: "Rico")) { Result in
//            if Result.idPartner != "" || Result.idPartner != nil {
//                print("save 3")
//                DispatchQueue.main.async {
//
//
//                }
//            } else {
//                print("error save")
//            }
//        }
//        PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "4", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Peter", phone: "62817271726", status: .active, airtableId: "4", address: "Jalan rusun apron", email: "def@def.com", ownerName: "Peter")) { Result in
//            if Result.idPartner != "" || Result.idPartner != nil {
//                print("save 4")
//                DispatchQueue.main.async {
//
//
//                }
//            } else {
//                print("error save")
//            }
//
//        }
//        PartnerRepository.shared.savePartner(partner: PartnerModel(idPartner: "5", idUser: UserDefaults.standard.string(forKey: "userID")!, idBusiness: UserDefaults.standard.string(forKey: "businessID")!, type: .suplier, name: "Valdo", phone: "62811227722", status: .active, airtableId: "5", address: "Jalan rusun apron", email: "efg@efg.com", ownerName: "Valdo")) { Result in
//            print("save 5")
//            print("added partner")
//        }
    //MARK: -transaction dummy
//
//    TransactionRepository.shared.saveTransaction(transaction: TransactionModel(idTransaction: "XJSHDS", idPartner: "1", totalPrice: 14000000, paymentCount: 2, document: "https://icloud.com", dueDate: "2021-09-08", createdDate: "2021-08-08", updatedDate: "2021-08-15", status: .ongoing, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!)) { Result in
//        print("added transaction")
//    }
//    TransactionRepository.shared.saveTransaction(transaction: TransactionModel(idTransaction: "XHJSAS", idPartner: "2", totalPrice: 10000000, paymentCount: 2, document: "https://icloud.com", dueDate: "2021-09-30", createdDate: "2021-08-08", updatedDate: "2021-08-30", status: .ongoing, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!)) { Result in
//        print("added transaction")
//    }
//    TransactionRepository.shared.saveTransaction(transaction: TransactionModel(idTransaction: "TEST", idPartner: "5", totalPrice: 999999, paymentCount: 1, document: "https://icloud.com", dueDate: "2021-08-08", createdDate: "2021-07-08", updatedDate: "2021-08-08", status: .paid, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!)) { Result in
//                print("added transaction")
//    }
//    TransactionRepository.shared.saveTransaction(transaction: TransactionModel(idTransaction: "XHUSSD", idPartner: "5", totalPrice: 10000000, paymentCount: 1, document: "https://icloud.com", dueDate: "2021-08-08", createdDate: "2021-07-08", updatedDate: "2021-08-08", status: .paid, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!)) { Result in
//        print("added transaction")
//    }
//    TransactionRepository.shared.saveTransaction(transaction: TransactionModel(idTransaction: "XJBCZZ", idPartner: "3", totalPrice: 8000000, paymentCount: 1, document: "https://icloud.com", dueDate: "2021-08-01", createdDate: "2021-07-01", updatedDate: "2021-07-01", status: .waiting, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!)) { Result in
//        print("added transaction")
//    }
//    TransactionRepository.shared.saveTransaction(transaction: TransactionModel(idTransaction: "XBJEGE", idPartner: "2", totalPrice: 6000000, paymentCount: 1, document: "https://icloud.com", dueDate: "2021-08-14", createdDate: "2021-07-14", updatedDate: "2021-07-14", status: .waiting, airtableId: "1", idBusiness: UserDefaults.standard.string(forKey: "businessID")!)) { Result in
//        print("added transaction")
//    }
//
//    //MARK: -dummy payment
//
//    PaymentRepository.shared.savePayments(payment: PaymentModel(idPayment: "PSBCBB", idTransaction: "XJSHDS", idUser: UserDefaults.standard.string(forKey: "userID")!, createdDate: "2021-08-15", amount: 8000000, document: "https://icloud.com", airtableId: "1")) { Result in
//        print("added payment")
//    }
//    PaymentRepository.shared.savePayments(payment: PaymentModel(idPayment: "PGHUYU", idTransaction: "XHJSAS", idUser: UserDefaults.standard.string(forKey: "userID")!, createdDate: "2021-08-30", amount: 5000000, document: "https://icloud.com", airtableId: "1")) { Result in
//        print("added payment")
//    }
//    PaymentRepository.shared.savePayments(payment: PaymentModel(idPayment: "PMNBAS", idTransaction: "XHUSSD", idUser: UserDefaults.standard.string(forKey: "userID")!, createdDate: "2021-08-08", amount: 10000000, document: "https://icloud.com", airtableId: "1")) { Result in
//        print("added payment")
//    }
}
}
