// error message if no palace selected, redirects to view page otherwise
function view_palace() {
    pid = document.getElementById("header_select").value;
    if (pid == -99) { // -99 hardcoded in header to handle no selection by user
        alert("No Selection made. Try again.");
    } else {
        window.location = "/view/" + pid;
    }
}

// confirmation message before deleting palace
function delete_palace() {
    pid = document.getElementById("header_select").value;
    if (confirm("Are you sure you'd like to delete the selected palace? This action cannot be undone.")){
        window.location = "/remove_palace/" + pid;
    }
}

// redirects to edit loci page
function edit_loci(id) {
    window.location = "/edit/" + id;
}
