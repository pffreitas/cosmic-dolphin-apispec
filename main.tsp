import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";

using TypeSpec.Http;
@service({
    title: "Cosmic Dolphin",
})
namespace CosmicDolphinService;

model InsertDocumentRequest {
    type: "webpage";
    source: string;
}

model NoteSection {
    type: NoteSectionType;
    content: Record<string>;
}

enum NoteSectionType {
    text: "text";
}

model Note {
    id?: int64;
    documentId: int64;
    title: string;
    summary: string;
    tags: string;
    sections: NoteSection[];
    userId: string;
    createdAt: utcDateTime;
}

@error
model Error {
    code: int32;
    message: string;
}

@route("/notes")
@tag("Notes")
interface Notes {
    @useAuth(BearerAuth)
    @get
    list(): Note[] | Error;

    @useAuth(BearerAuth)
    @get
    read(@path id: string): Note | Error;
}

@route("/insert-document")
@tag("Documents")
interface DocumentService {
    @useAuth(BearerAuth)
    @post
    insertDocument(@body body: InsertDocumentRequest): void;
}
