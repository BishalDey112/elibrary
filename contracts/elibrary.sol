// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ELibrary {
    // Structure to represent a digital book
    struct Book {
        uint id;
        string title;
        string author;
        string ipfsHash;  // IPFS hash of the book file
        address uploader;
        bool isAvailable;
    }

    // Mapping of book ID to Book structure
    mapping(uint => Book) public books;
    uint public bookCount = 0;

    // Event to notify when a new book is uploaded
    event BookUploaded(
        uint id,
        string title,
        string author,
        string ipfsHash,
        address uploader
    );

    // Function to upload a new book
    function uploadBook(string memory _title, string memory _author, string memory _ipfsHash) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_author).length > 0, "Author cannot be empty");
        require(bytes(_ipfsHash).length > 0, "IPFS hash cannot be empty");

        // Increment book count
        bookCount++;

        // Add the new book to the mapping
        books[bookCount] = Book(bookCount, _title, _author, _ipfsHash, msg.sender, true);

        // Emit the event
        emit BookUploaded(bookCount, _title, _author, _ipfsHash, msg.sender);
    }

    // Function to retrieve book details by ID
    function getBook(uint _id) public view returns (string memory, string memory, string memory, address, bool) {
        require(_id > 0 && _id <= bookCount, "Invalid book ID");
        Book memory book = books[_id];
        return (book.title, book.author, book.ipfsHash, book.uploader, book.isAvailable);
    }

    // Function to mark a book as unavailable (e.g., borrowed)
    function markBookAsUnavailable(uint _id) public {
        require(_id > 0 && _id <= bookCount, "Invalid book ID");
        require(msg.sender == books[_id].uploader, "Only the uploader can mark the book as unavailable");
        books[_id].isAvailable = false;
    }

    // Function to mark a book as available (e.g., returned)
    function markBookAsAvailable(uint _id) public {
        require(_id > 0 && _id <= bookCount, "Invalid book ID");
        require(msg.sender == books[_id].uploader, "Only the uploader can mark the book as available");
        books[_id].isAvailable = true;
    }
}
