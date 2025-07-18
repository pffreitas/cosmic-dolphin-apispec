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
    body: string;
    tags: string[];
    type: NoteType;
    userId: string;
    createdAt: string;
    resources: Resource[];
}

model CreateNoteRequest {
    body: string;
    type: NoteType;
}

model Resource {
    title: string;
    icon: string;
    source: string;
    type: ResourceType;
}

enum ResourceType {
    web_page: "web_page",
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
