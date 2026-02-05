package com.trifunovska.internship.service;

import com.trifunovska.internship.model.ApplicationDocument;
import com.trifunovska.internship.model.InternshipApplication;
import com.trifunovska.internship.model.enums.FileType;
import com.trifunovska.internship.repository.ApplicationDocumentRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ApplicationDocumentService {
    private final ApplicationDocumentRepository applicationDocumentRepository;

    public ApplicationDocumentService(ApplicationDocumentRepository applicationDocumentRepository) {
        this.applicationDocumentRepository = applicationDocumentRepository;
    }

    @Transactional
    public void create(InternshipApplication application,
                       MultipartFile file,
                       FileType type) {

        if (file == null || file.isEmpty())
            throw new IllegalArgumentException("File is null or empty");

        String path = type + "_" + file.getOriginalFilename();

        ApplicationDocument document = new ApplicationDocument();
        document.setApplication(application);
        document.setType(type);
        document.setFilePath(path);

        applicationDocumentRepository.save(document);
    }
}
