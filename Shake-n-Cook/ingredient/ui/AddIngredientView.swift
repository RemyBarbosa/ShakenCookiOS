//
//  AddIngredientView.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 18/03/2023.
//

import SwiftUI
import AVFoundation

struct AddIngredientView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = AddIngredientViewModel(ingredientRepository: IngredientRepository())
    var lastBarcodeValue: String?
    var onDismiss: ((Ingredient) -> Void)?
    @State var isTitleFilled: Bool = true
    @State var isPictureFilled: Bool = true
    @State var isBarcodeFilled: Bool = true
    @State private var showImagePicker = false
    @State private var hasCameraAccess = false
    @State private var showAlert = false
    @State private var showErrorAlert = false
    @State private var isShowingScanner = false
    let numberFormatter = DoubleNumberFormatter()
    
    
    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    fileprivate func nutrientView(field:String, textField:Binding<Double>) -> some View {
        return HStack {
            TextField("1000", value: textField, formatter: numberFormatter)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .foregroundColor(Color("textColor"))
            Image(field)
                .resizable()
                .frame(width: 25, height: 25)
                .padding(.leading, 8).padding(.trailing, 4)
                .foregroundColor(Color("iconButtonColor"))
            Text(field)
                .font(.body)
                .foregroundColor(Color("textColor"))
            Spacer()
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            ScrollView {
                VStack { TextField("Put the exact name of the ingredient please", text: $viewModel.titleText)
                        .padding(.horizontal).padding(.top, 50).multilineTextAlignment(.center).onAppear() {
                            requestCameraAccess { granted in
                                hasCameraAccess = granted
                                showAlert = !granted
                            }
                        }.alert(isPresented: $showAlert) {
                            Alert(title: Text("Camera Access Denied"),
                                  message: Text("Please allow camera access in Settings."),
                                  dismissButton: .default(Text("OK"), action: {
                                presentationMode.wrappedValue.dismiss()
                            }))
                        }.onAppear {
                            viewModel.barcodeValue = lastBarcodeValue ?? viewModel.barcodeDefaultValue
                        }
                    if !isTitleFilled && viewModel.titleText.isEmpty {
                        Text("Please enter the name of the ingredient")
                            .foregroundColor(.red)
                            .padding(.bottom, 10)
                    }
                    
                    VStack {
                        Text("Please take a picture really close of the ingredient")
                        
                        if let image = viewModel.image {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .cornerRadius(200)
                                .overlay(
                                    FloatingActionButtonView(label: {
                                        Image(systemName: "camera")
                                    }, width: 40, height: 40) {
                                        showImagePicker = true
                                    }
                                        .padding(.bottom, -30)
                                        .padding(.trailing, -30),
                                    alignment: .bottomTrailing
                                ).padding(.top, 20)
                        } else {
                            FloatingActionButtonView(label: {
                                Image(systemName: "camera")
                            }) {
                                showImagePicker = true
                            }.padding(.top, 20)
                        }
                        if !isPictureFilled && viewModel.image == nil  {
                            Text("Please take a picture of the ingredient")
                                .foregroundColor(.red)
                                .padding(.bottom, 10)
                        }
                    }.padding(.top, 30)
                    
                    VStack {
                        Text("Please scan the barcode of the ingredient")
                        
                        if viewModel.barcodeValue == viewModel.barcodeDefaultValue {
                            FloatingActionButtonView(label: {
                                Image(systemName: "barcode.viewfinder")
                            }) {
                                isShowingScanner = true
                            }
                            
                        } else {
                            HStack {
                                Image(systemName: "barcode")
                                Text(viewModel.barcodeValue)
                            }.padding(.top, 20)
                                .overlay(
                                    FloatingActionButtonView(label: {
                                        Image(systemName: "barcode.viewfinder")
                                    }, width: 40, height: 40) {
                                        isShowingScanner = true
                                    }
                                        .padding(.bottom, -30)
                                        .padding(.trailing, -30),
                                    alignment: .bottomTrailing
                                )
                        }
                        if !isBarcodeFilled && viewModel.barcodeValue == viewModel.barcodeDefaultValue  {
                            Text("Please scan your product")
                                .foregroundColor(.red)
                                .padding(.bottom, 10)
                        }
                        
                    }.padding(.top, 30)
                    
                    
                    HStack {
                        Text("Enter the nutirents for 100 ")
                        let quantityKinds = [QuantityKind.g, QuantityKind.ml]
                        Menu {
                            ForEach(quantityKinds, id: \.self) { kind in
                                Button(action: { viewModel.kind = kind }) {
                                    Text(kind.title)
                                }
                            }
                        } label: {
                            Text(viewModel.kind.rawValue)
                            Image(systemName: "chevron.up.chevron.down")
                        }
                        .padding(.trailing)
                    }.padding(.top, 30)
                    
                    
                    VStack {
                        nutrientView(field: "kcal", textField: $viewModel.kcal)
                        nutrientView(field: "carbs", textField: $viewModel.carbs)
                        nutrientView(field: "fat", textField: $viewModel.fat)
                        nutrientView(field: "prot", textField: $viewModel.prot)
                        nutrientView(field: "fiber", textField: $viewModel.fiber)
                        
                        Text("Please fill all nutrients carefully 🙏")
                                .foregroundColor(.red)
                                .padding(.bottom, 10)
                    }.padding(.top, 20)
                    
                    Spacer()
                    HStack {
                        FloatingActionButtonView(
                            label: {
                                Image(systemName: "checkmark")
                            }
                        ) {
                            if (viewModel.titleText.isEmpty) {
                                isTitleFilled = false
                                return
                            } else {
                                isTitleFilled = true
                            }
                            
                            if (viewModel.image == nil) {
                                isPictureFilled = false
                                return
                            } else {
                                isPictureFilled = true
                            }
                            
                            if (viewModel.barcodeValue == viewModel.barcodeDefaultValue) {
                                isBarcodeFilled = false
                                return
                            } else {
                                isBarcodeFilled = true
                            }
                            
                            viewModel.createIngredient()
                        }.padding()
                    }
                    
                    
                }
            }
            if case .loading = viewModel.state {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error on Upload"),
                  message: Text("Something went wrong... Please try again"),
                  dismissButton: .default(Text("OK"), action: {
                showErrorAlert = false
            }))
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
            showImagePicker = false
        }) {
            ImagePickerView(sourceType: .camera) { result in
                switch result {
                case .success(let image):
                    viewModel.image = image
                case .failure(let error):
                    print("Error picking image: \(error)")
                }
                showImagePicker = false
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            RSBarcodeScannerView(isPresented: $isShowingScanner) { scannedBarcode in
                if let barcode = scannedBarcode {
                    viewModel.barcodeValue = barcode
                }
            }
        }
        .onChange(of: viewModel.state) { state in
            switch viewModel.state {
            case .idle :
                print("idle")
            case .error :
                showErrorAlert = true
            case .loading :
                print("loading")
            case .ingredient(let ingredient) :
                self.onDismiss?(ingredient)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct AddIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        AddIngredientView()
    }
}

