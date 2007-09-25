//
// WOPathUtilities.h
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

//! Utility function that returns the absolute path to \p tool.
//! First searches for \p tool in the locations specified by the PATH environment variable.
//! If the PATH environment variable is not set tries the locations defined in the user.cs_path sysctl setting.
//! Returns nil if the tool cannot be found.
//! \exception NSInternalInconsistencyException thrown if \p tool is nil.
NSString *path_for_tool(NSString *tool);
