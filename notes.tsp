import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "./pipeline.tsp";

using TypeSpec.Http;
namespace CosmicDolphinService;

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
    tags: string[];
    type: NoteType;
    sections: NoteSection[];
    userId: string;
    createdAt: utcDateTime;
    pipelines: Pipeline[];
}

model CreateNoteRequest {
    body: string;
    type: NoteType;
}


@route("/notes")
@tag("Notes")
interface Notes {
    @useAuth(BearerAuth)
    @get
    findAll(): Note[] | CosmicError;

    @useAuth(BearerAuth)
    @get
    findById(@path id: string): Note | CosmicError;

    @useAuth(BearerAuth)
    @post
    create(@body request: CreateNoteRequest): {
        @statusCode statusCode: 201;
        @body body: Note;
    };
}