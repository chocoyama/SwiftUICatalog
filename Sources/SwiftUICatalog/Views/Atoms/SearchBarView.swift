//
//  SearchBarView.swift
//  stores.native
//
//  Created by Takuya Yokoyama on 2019/11/02.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI
import Combine

public struct SearchBarView: UIViewRepresentable {
    public class Coordinator: NSObject, UISearchBarDelegate {
        private let onTextDidChange: PassthroughSubject<String, Never>
        private let onSearchButtonClicked: PassthroughSubject<String, Never>
        
        init(onTextDidChange: PassthroughSubject<String, Never>, onSearchButtonClicked: PassthroughSubject<String, Never>) {
            self.onTextDidChange = onTextDidChange
            self.onSearchButtonClicked = onSearchButtonClicked
        }
        
        public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            onTextDidChange.send(searchText)
        }
        
        public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            onSearchButtonClicked.send(searchBar.text ?? "")
        }
    }
    
    private let placeholder: String
    private let onTextDidChange: PassthroughSubject<String, Never>
    private let onSearchButtonClicked: PassthroughSubject<String, Never> = .init()
    
    public init(text onTextDidChange: PassthroughSubject<String, Never>, placeholder: String) {
        self.onTextDidChange = onTextDidChange
        self.placeholder = placeholder
    }
    
    public func makeCoordinator() -> SearchBarView.Coordinator {
        Coordinator(onTextDidChange: onTextDidChange,
                    onSearchButtonClicked: onSearchButtonClicked)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<SearchBarView>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = placeholder
        searchBar.delegate = context.coordinator
        searchBar.keyboardType = .default
        searchBar.returnKeyType = .search
        searchBar.autocapitalizationType = .none
        searchBar.searchBarStyle = .minimal
        return searchBar
    }
    
    public func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBarView>) {
    }
    
    public func onSearchButtonClicked(perform action: @escaping ((String) -> Void)) -> some View {
        // TODO: Cancellablesの扱い考える
        let _ = onSearchButtonClicked
            .subscribe(on: DispatchQueue.main)
            .sink(receiveValue: action)
        return self
    }
}
