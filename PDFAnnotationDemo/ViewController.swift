//
//  ViewController.swift
//  PDFAnnotationDemo
//
//  Created by Maksym Musiienko on 3/12/18.
//  Copyright © 2018 Maksym Musiienko. All rights reserved.
//

import PDFKit

class ViewController: UIViewController {

    private let document = PDFDocument(url: URL(string: "http://www.nimoz.pl/files/publications/4/loremipsum.pdf")!)!
    private let pdfView = PDFView()

    override func viewDidLoad() {
        super.viewDidLoad()
        document.delegate = self
        pdfView.minScaleFactor = 1.0
        pdfView.maxScaleFactor = 5.0
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.document = document
        view.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.leftAnchor.constraint(equalTo: view.leftAnchor),
            pdfView.topAnchor.constraint(equalTo: view.topAnchor),
            pdfView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        view.layoutIfNeeded()
        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
    }

    @IBAction private func createAnnotation(_ sender: UIBarButtonItem) {
        document.findString("Integer bibendum", withOptions: [.caseInsensitive])
    }

    @IBAction private func removeAnnotation(_ sender: UIBarButtonItem) {
        if let page = document.page(at: 0) {
            page.annotations.forEach(page.removeAnnotation)
        }
    }
}

extension ViewController: PDFDocumentDelegate {

    func didMatchString(_ instance: PDFSelection) {
        guard let page = instance.pages.first else { return }
        instance.draw(for: page, active: true)
        let annotation = PDFAnnotation(bounds: instance.bounds(for: page), forType: .highlight, withProperties: nil)
        page.addAnnotation(annotation)
    }
}
