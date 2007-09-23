    # records the position of the current character
    # used for simple captures of ASCII text such as blob ids, numeric escapes and unquoted paths
    action set_mark                     { mark = p; }

    # initializes the buffer from the block of memory previously marked with set_mark up to the current location
    action copy_to_buffer
    {
        buffer = [[NSString alloc] initWithBytesNoCopy:mark length:(p - mark) encoding:NSASCIIStringEncoding freeWhenDone:NO];
    }

        // note that the atoi() call here could be replaced with an "all transitions" action and some bitwise shift arithmetic
        from_file_chunk_start = atoi(location_pointer);
        // note that the atoi() call here could be replaced with an "all transitions" action and some bitwise shift arithmetic
        to_file_chunk_start = atoi(location_pointer);
    }

    # called when starting a new file, finalizes any existing changes and files
    action start_file
    {
        if (change) [file appendChange:change];
        change = nil;
        if (file) [diff appendFile:file];
        file = [WOFile file];
    }

    action store_from_spec  { [file setFromPath:buffer]; }
    action store_to_spec    { [file setToPath:buffer]; }
    action store_from_hash  { [file setFromHash:buffer]; }
    action store_to_hash    { [file setToHash:buffer]; }

    # called on entering a new chunk, finalizes any existing changes
    action reset_line_counters
    {
        if (change)
        {
            [file appendChange:change];
            change  = nil;
        }
        from_cursor = from_file_chunk_start > 0 ? from_file_chunk_start - 1 : 0;
        to_cursor   = to_file_chunk_start > 0 ? to_file_chunk_start - 1 : 0;
    }

    # called on scanning a line of context (neither addition nor removal), finalizes any existing change
    action record_context_line
    {
        if (change)
        {
            [file appendChange:change];
            change = nil;
        }
        from_cursor++;
        to_cursor++;
    }

    # called on scanning a deletion line, starts a new change if necessary
    action record_deletion_line
    {
        from_cursor++;
        if (!change)
            change = [WOChange changeWithDeletionAtLine:from_cursor];
        else
            [change addDeletionAtLine:from_cursor];
    }

    # called on scanning an insertion line, starts a new change if necessary
    action record_insertion_line
    {
        to_cursor++;
        if (!change)
            change = [WOChange changeWithInsertionAtLine:to_cursor];
        else
            [change addInsertionAtLine:to_cursor];
                              | "index" sp %set_mark hash %copy_to_buffer %store_from_hash ".."
                                           %set_mark hash %copy_to_buffer %store_to_hash (sp mode)? linefeed ;
    dev_null                  = "/dev/null" @{ buffer = @"/dev/null"; };
    numeric_escape            = "\\" digit digit digit ;
    escape                    = numeric_escape | tab_escape | linefeed_escape | quote_escape | backslash_escape ;
    quoted_from_filespec      = '"a/' %set_mark (escape | [^"\\\n])+ %copy_to_buffer '"' ;
    unquoted_from_filespec    = "a/" %set_mark (any - linefeed)+ %copy_to_buffer ;
    quoted_to_filespec        = '"b/' %set_mark (escape | [^"\\\n])+ %copy_to_buffer '"' ;
    unquoted_to_filespec      = "b/" %set_mark (any - linefeed)+ %copy_to_buffer ;
    from_spec                 = "---" sp from_filespec linefeed %store_from_spec ;
    to_spec                   = "+++" sp to_filespec linefeed %store_to_spec ;
    context_line              = sp >record_context_line (any - linefeed)* linefeed ;
    deletion_line             = "-" >record_deletion_line (any - linefeed)* linefeed ;
    insertion_line            = "+" >record_insertion_line (any - linefeed)* linefeed ;
    newline_warning           = "\\ No newline at end of file" linefeed? ;
    chunk                     = range_spec %reset_line_counters
                              . (context_line | deletion_line | insertion_line | newline_warning)+ ;
    file_block                = git_diff_header %start_file

    main                      := file_block+ ;
    diff = [WODiff diff];

    // finalize and dangling changes/files
    if (change) [file appendChange:change];
    if (file)   [diff appendFile:file];
    NSLog(@"debug info:\n %@", diff);
    NSLog(@"consumed all input? %d", p == pe);
    return (p == pe) ? diff : nil;                  // return nil if did not consume all the input