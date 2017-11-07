# Zype Client
My Zype Client application provides a simple UI that pulls data from the Zype API, allowing the user to view a paginated list of videos, click through to watch a video, and log in to view paywalled videos.

Given that all data comes from the Zype video and OAUTH APIs, and login state would persisted in the user session, I decided to forgo the Model layer entirely, implementing all logic within Videos and Sessions controllers.

# Routes

	GET /               videos#index
	GET /videos         videos#index
	GET /videos/:id  	videos#show

	GET /login			sessions#new
	POST /login		    sessions#create
	
	GET /logout			sessions#destroy

# Controllers

## VideosController

The **videos#index** controller action accepts one optional parameter: page.  The controller makes a call to the Zype videos API, retreiving JSON data for a page's worth of videos. A thumbnail url and title are rendered for each video object retreived.

**videos#show** accepts a single parameter: id.  The controller action makes an call to the Zype videos API for a single video object. Upon retreival, the video details are checked for a subscription requirement, and the user session is checked for an access_token. If the video requires subscription and the user isn't logged in, the user is redirected to a login paywall, otherwise they are granted access to the video.

VideosController also defines a number of private and helper methods for URL generation and subscription checking.

## SessionsController
**sessions#new** renders a login screen that can be accessed directly via GET /login, or via redirect following attempted access of a protected video. sessions#new accepts one optional parameter:  video_id.  If this parameter is present, the user will be redirected to the corresponding protected video after authentication, otherwise they will be redirected to root.

**sessions#create** attempts to authenticate the user against the Zype OAuth API.  Successful authentication results in persistence of the returned access token in the user session, and a redirect to either the referring protected video page, or page 1 of videos#index.  Failed authentication denies access to the protected video and shows the user a flash error message.

**sessions#destroy** removes the access_token from the user's session, effectively logging them out, and redirects to page 1 of videos#index

SessionsController also defines private methods for URL generation, easy access to secrets, and Oauth token retreival.

# Secrets

All Zype API keys are stored in Rails 5.1 encrypted secrets


