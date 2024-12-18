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

enum NoteType {
    fup: "fup",
    chatter: "chatter",
    knowledge: "knowledge",
    task: "task",
}

enum NoteSectionType {
    text: "text",
}

model Note {
    id?: int64;
    documentId?: int64;
    title: string;
    summary: string;
    tags: string;
    type: NoteType;
    sections: NoteSection[];
    userId: string;
    createdAt: utcDateTime;
}

model CreateNoteRequest {
    body: string;
    type: NoteType;
}

@error
model CosmicError {
    code: int32;
    message: string;
}

@route("/notes")
@tag("Notes")
interface Notes {
    @useAuth(BearerAuth)
    @get
    list(): Note[] | CosmicError;

    @useAuth(BearerAuth)
    @get
    read(@path id: string): Note | CosmicError;

    @useAuth(BearerAuth)
    @post
    create(@body request: CreateNoteRequest): {
        @statusCode statusCode: 201;
        @body body: Note;
    };
}

@route("/notes/stream")
@tag("Notes")
interface NotesWebSocket {
    @useAuth(BearerAuth)
    @get
    websocketConnection(): void;
}

model WebSocketMessage {
    event: string; // e.g., "note_created", "note_updated"
    data: Note | string; // Data payload for the event
}

@route("/insert-document")
@tag("Documents")
interface DocumentService {
    @useAuth(BearerAuth)
    @post
    insertDocument(@body body: InsertDocumentRequest): void;
}
