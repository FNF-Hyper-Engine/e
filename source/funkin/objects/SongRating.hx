package funkin.objects;

class SongRating
{
	public var SongResults:SongResults;
	public static  var base:SongResults = {
		song: "Bopeebo",
		diff: "normal",
		week: "week1",
		sicks: 0,
		goods: 0,
		bads: 0,
		shits: 0,
		score: 0.0,
		songSpeed: 1.0,
		players: ["dad", "gf", "bf"]
	};

	public function new()
	{
		this.SongResults = SongRating.base;
	}
}
