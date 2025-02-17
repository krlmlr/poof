% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/new_trick.R
\name{new_trick}
\alias{new_trick}
\title{Create a new trick}
\usage{
new_trick(label, condition, action)
}
\arguments{
\item{label}{A string}

\item{condition}{A one sided formula, using condition helpers and context informers, whose
right hand side expressions returns a boolean when evaluated by {poof}}

\item{action}{A one sided formula, using action helpers and context informers, whose
right hand side triggers the desired actions when evaluated by {poof}}
}
\value{
a "poof_trick" object
}
\description{
Create a trick to be used as an argument in \code{poof::add_tricks()}, mainly useful
to store tricks in packages
}
\examples{
new_trick(
"Edit user '.Rprofile'",
~ selection_is_empty(),
~ usethis::edit_r_profile()
)
}
